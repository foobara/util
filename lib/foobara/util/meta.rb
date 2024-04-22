module Foobara
  module Util
    class ParentModuleDoesNotExistError < StandardError
      attr_reader :name, :parent_name

      def initialize(name:, parent_name:)
        @name = name
        @parent_name = parent_name

        super("Parent module #{parent_name} does not exist for #{name}.")
      end
    end

    module_function

    def make_class(name, superclass = nil, which: :class, tag: false, &block)
      name = name.to_s if name.is_a?(::Symbol)

      if superclass.is_a?(Class)
        superclass = superclass.name
      end

      inherit = superclass ? " < ::#{superclass}" : ""

      superclass ||= :Object

      name = name[2..] if name.start_with?("::")

      if !Object.const_defined?(name) && tag
        should_tag = true
      end

      parent_name = parent_module_name_for(name)

      if parent_name && !Object.const_defined?(parent_name)
        raise ParentModuleDoesNotExistError.new(name:, parent_name:)
      end

      # rubocop:disable Security/Eval, Style/DocumentDynamicEvalDefinition
      eval(<<~RUBY, binding, __FILE__, __LINE__ + 1)
        #{which} ::#{name}#{inherit}
        end
      RUBY
      # rubocop:enable Security/Eval, Style/DocumentDynamicEvalDefinition

      klass = Object.const_get(name)

      if should_tag
        klass.instance_variable_set(:@foobara_created_via_make_class, true)
      end

      if block
        if which == :module
          klass.module_eval(&block)
        else
          klass.class_eval(&block)
        end
      end

      klass
    end

    def make_class_p(name, superclass = nil, which: :class, tag: false, &)
      make_class(name, superclass, which:, tag:, &)
    rescue ParentModuleDoesNotExistError => e
      make_class_p(e.parent_name, which: :module, tag:, &)
      make_class(name, superclass, which:, tag:, &)
    end

    # TODO: Kind of weird that make_module is implemented in terms of make_class instead of the other way around
    def make_module(name, &)
      make_class(name, which: :module, &)
    end

    def make_module_p(name, tag: false, &)
      make_class_p(name, which: :module, tag:, &)
    end
  end
end
