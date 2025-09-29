module Foobara
  module Util
    class ReferencePathPart
      attr_accessor :referencer, :referencee, :via, :via_type

      def initialize(referencer, referencee, via, via_type)
        self.referencer = referencer
        self.referencee = referencee
        self.via = via
        self.via_type = via_type
      end
    end

    class << self
      def object_id_to_object(object_id)
        ObjectSpace._id2ref(object_id)
      rescue RangeError
        nil
      end

      def referencing_paths(object)
        paths = _referencing_paths(object.object_id, object_id_referenced_by_map)
        paths.sort_by!(&:size)
        paths.reverse!
        paths
      end

      private

      def _referencing_paths(object_id, map, seen = Set.new, parts = [], paths = [])
        seen << object_id

        path_parts = map[object_id]&.uniq&.reject do |path_part|
          seen.include?(path_part.referencer)
        end&.uniq

        if path_parts && !path_parts.empty?
          path_parts.each do |path_part|
            _referencing_paths(path_part.referencer, map, seen, [*parts, path_part], paths)
          end
        else
          resolved_parts = []

          parts.each do |part|
            referenced_by = object_id_to_object(part.referencer)

            via = part.via

            via = case part.via_type
                  when :constant
                    "::#{via}"
                  when :array_index, :hash_value
                    "[#{via.inspect}]"
                  when :hash_key
                    "{#{via}}"
                  when :ivar
                    via
                  else
                    # :nocov:
                    raise "Unexpected via_type #{part.via_type}"
                    # :nocov:
                  end

            class_part = if referenced_by.is_a?(Module)
                           name = referenced_by.name

                           if name
                             name
                           elsif referenced_by.is_a?(Class)
                             "AnonClass:#{referenced_by.object_id}"
                           else
                             "AnonModule:#{referenced_by.object_id}"
                           end
                         else
                           "<#{referenced_by.class}:#{referenced_by.object_id}>"
                         end

            resolved_parts << "#{class_part}#{via}"
          end

          resolved_parts.reverse!

          paths << resolved_parts
        end

        paths
      end

      def all_objects
        ObjectSpace.each_object.to_a
      end

      UNINTERESTING_REFERENCE_CLASSES = [
        "String",
        "Proc",
        "Time",
        "Regexp",
        "WeakRef",
        "Thread::Mutex",
        "Gem::Requirement",
        "Symbol"
      ].freeze

      private_constant :UNINTERESTING_REFERENCE_CLASSES

      def object_id_references_map
        references = {}

        objects = all_objects

        uninteresting_classes = UNINTERESTING_REFERENCE_CLASSES.map do |class_name|
          if Object.const_defined?(class_name)
            Object.const_get(class_name)
          end
        end.compact

        objects = objects.reject do |object|
          uninteresting_classes.include?(object.class)
        end

        objects.each do |object|
          # rubocop:disable Lint/HashCompareByIdentity
          references[object.object_id] = object_id_references(object)
          # rubocop:enable Lint/HashCompareByIdentity
        end

        references
      end

      def object_id_referenced_by_map
        referenced_by = {}

        object_id_references_map.each_value do |references|
          references.each do |referenced_path_part|
            referenced_object_id = referenced_path_part.referencee

            referenced_by[referenced_object_id] ||= []
            referenced_by[referenced_object_id] << referenced_path_part
          end
        end

        referenced_by
      end

      def object_id_references(object)
        object_id = object.object_id

        references = object.instance_variables.map do |ivar|
          ReferencePathPart.new(
            object_id,
            object.instance_variable_get(ivar).object_id,
            ivar,
            :ivar
          )
        end

        case object
        when ::Module
          object.constants(false).each do |constant_name|
            references << ReferencePathPart.new(
              object_id,
              object.const_get(constant_name).object_id,
              constant_name,
              :constant
            )
            # rubocop:disable Lint/RescueException
          rescue Exception
            # rubocop:enable Lint/RescueException
            nil
          end
        when ::Array, ::Set

          object.each.with_index do |element, index|
            references << ReferencePathPart.new(
              object_id,
              element.object_id,
              index,
              :array_index
            )
          end

        when ::Hash
          object.each_pair do |k, v|
            references << ReferencePathPart.new(object_id, k.object_id, k, :hash_key)
            references << ReferencePathPart.new(object_id, v.object_id, k, :hash_value)
          end
        end

        references
      end
    end
  end
end
