module Foobara
  module Util
    module_function

    def deep_stringify_keys(object)
      case object
      when ::Array
        object.map { |element| deep_stringify_keys(element) }
      when ::Hash
        object.to_h do |k, v|
          [k.is_a?(::Symbol) ? k.to_s : k, deep_stringify_keys(v)]
        end
      else
        object
      end
    end

    def deep_dup(object)
      case object
      when ::Array
        object.map { |element| deep_dup(element) }
      when ::Hash
        object.to_h { |k, v| [deep_dup(k), deep_dup(v)] }
      when ::Class
        # we get super wacky results in some areas where we use entity classes as short-cuts for their entity types
        # if we dup those classes (they lose their name, for example)
        object
      else
        object.dup
      end
    end
  end
end
