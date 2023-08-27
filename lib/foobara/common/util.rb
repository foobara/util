module Foobara
  module Util
    module_function

    def module_for(mod)
      name = mod.name[/(.*)::/, 1]
      Object.const_get(name) if name
    end

    def power_set(array)
      return [[]] if array.empty?

      head, *tail = array
      subsets = power_set(tail)
      subsets + subsets.map { |subset| [head, *subset] }
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
        is_a = Array.wrap(is_a)
        extends = Array.wrap(extends)

        mod.constants.map { |const| constant_value(mod, const) }.select do |object|
          (is_a.blank? || is_a.any? { |klass| object.is_a?(klass) }) &&
            (extends.blank? || (object.is_a?(Class) && extends.any? { |klass| object.ancestors.include?(klass) }))
        end
      end
    end

    def require_directory(directory)
      require_pattern("#{directory}/**/*.rb")
    end

    def require_pattern(glob)
      files = Dir[glob].sort_by(&:length).reverse

      if files.empty?
        # :nocov:
        raise "Didn't find anything to require for #{glob}"
        # :nocov:
      end

      files.each do |f|
        require f
      end
    end

    def all_symbolic_keys?(hash)
      all_symbolic_elements?(hash.keys)
    end

    def all_symbolizable_keys?(hash)
      all_symbolizable_elements?(hash.keys)
    end

    def all_symbolic_elements?(array)
      array.all? { |key| key.is_a?(Symbol) || key.is_a?(String) }
    end

    def all_symbolizable_elements?(array)
      array.all? { |key| key.is_a?(Symbol) || key.is_a?(String) }
    end

    def args_and_opts_to_opts(args, opts)
      if !args.is_a?(Array) || args.size > 1
        # :nocov:
        raise ArgumentError, "args must be an array of 0 or 1 hashes but received #{args}"
        # :nocov:
      end

      unless opts.is_a?(Hash)
        # :nocov:
        raise ArgumentError, "opts must be a hash not a #{opts}"
        # :nocov:
      end

      (args.first || {}).merge(opts)
    end

    def arg_and_opts_to_arg(arg, opts)
      if arg.present?
        if opts.present?
          unless opts.is_a?(Hash)
            # :nocov:
            raise ArgumentError, "opts must be a hash not a #{opts}"
            # :nocov:
          end

          unless arg.is_a?(Hash)
            # :nocov:
            raise ArgumentError, "arg must be a hash if present when opts is present"
            # :nocov:
          end

          arg.merge(opts)
        else
          arg
        end
      else
        opts.presence
      end
    end

    # Strange utility method here...
    # idea is there's a method that takes 0 or 1 arguments which may or may not be a hash.
    # To make sure we don't act like there's an argument when there's not or fail to combine
    # parts of the hash that wind up in opts, this method comines it into an array of 0 or 1
    # argument with stuff merged into the argument if needed.
    def args_and_opts_to_args(args, opts)
      unless args.is_a?(Array)
        # :nocov:
        raise ArgumentError, "args must be an array of 0 or 1 hashes but received #{args}"
        # :nocov:
      end

      case args.size
      when 0
        Array.wrap(arg_and_opts_to_arg(nil, opts))
      when 1
        # Do not go from 1 argument to 0. ie, [nil] should return [nil] not [].
        if opts.present?
          arg = args.first

          unless arg.is_a?(::Hash)
            # :nocov:
            raise ArgumentError, "Expected #{arg.inspect} to be a Hash"
            # :nocov:
          end

          [arg_and_opts_to_arg(args.first, opts)]
        else
          args
        end

        [arg_and_opts_to_arg(args.first, opts)]
      else
        # :nocov:
        raise ArgumentError, "args must be an array of 0 or 1 hashes but received #{args}"
        # :nocov:
      end
    end
  end
end
