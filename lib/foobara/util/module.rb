module Foobara
  module Util
    module_function

    def module_for(mod)
      name = mod.name

      return unless name

      name = parent_module_name_for(mod.name)
      Object.const_get(name) if name
    end

    def parent_module_name_for(module_name)
      module_name[/(.*)::/, 1]
    end

    def non_full_name(mod)
      name = if mod.is_a?(::String)
               mod
             else
               mod.name
             end

      name&.[](/([^:]+)\z/, 1)
    end

    def non_full_name_underscore(mod)
      underscore(non_full_name(mod))
    end

    def constant_value(mod, constant, inherit: false)
      if mod.constants(inherit).include?(constant.to_sym)
        mod.const_get(constant, inherit)
      end
    end

    def constant_values(mod, is_a: nil, extends: nil, inherit: false)
      if inherit && !mod.is_a?(Class)
        # :nocov:
        raise "Cannot pass inherit: true for something that is not a Class"
        # :nocov:
      end

      if inherit
        superklass = mod.superclass
        values = constant_values(mod, is_a:, extends:)
        if superklass == Object
          values
        else
          [
            *values,
            *constant_values(superklass, is_a:, extends:, inherit:)
          ]
        end
      else
        is_a = Util.array(is_a)
        extends = Util.array(extends)

        mod.constants.map { |const| constant_value(mod, const) }.select do |object|
          (is_a.nil? || is_a.empty? || is_a.any? { |klass| object.is_a?(klass) }) &&
            (extends.nil? || extends.empty? || (object.is_a?(Class) && extends.any? do |klass|
              object.ancestors.include?(klass)
            end))
        end.compact
      end
    end

    def const_get_up_hierarchy(mod, name)
      mod.const_get(name)
    rescue NameError => e
      if mod == Object || e.message !~ /uninitialized constant (.*::)?#{name}\z/
        # :nocov:
        raise
        # :nocov:
      end

      mod = if mod.name&.include?("::")
              module_for(mod)
            else
              Object
            end

      const_get_up_hierarchy(mod, name)
    end

    def remove_constant(const_name)
      *path, name = const_name.split("::")
      mod = path.inject(Object) { |m, constant| m.const_get(constant) }

      mod.send(:remove_const, name)
    end
  end
end
