module Foobara
  module Util
    module_function

    def module_for(mod)
      name = mod.name&.[](/(.*)::/, 1)
      Object.const_get(name) if name
    end

    def non_full_name(mod)
      mod.name&.[](/([^:]+)\z/, 1)
    end

    def non_full_name_underscore(mod)
      underscore(non_full_name(mod))
    end

    def classify(string)
      camelize(string, true)
    end

    def camelize(string, upcase_first = false)
      return nil if string.nil?

      if string.is_a?(::Symbol)
        string = string.to_s
      end

      retval = ""

      string.each_char do |char|
        if char == "_"
          upcase_first = true
        elsif upcase_first
          retval << char.upcase
          upcase_first = false
        else
          retval << char.downcase
        end
      end

      retval
    end

    CAPS = ("A".."Z")

    def constantify(string)
      return nil if string.nil?

      if string.is_a?(::Symbol)
        string = string.to_s
      end

      if string.chars.all? { |char| CAPS.include?(char) }
        string.dup
      else
        underscore(string).upcase
      end
    end

    def constantify_sym(string)
      constantify(string)&.to_sym
    end

    def underscore(string)
      return nil if string.nil?

      if string.is_a?(::Symbol)
        string = string.to_s
      end

      return "" if string.empty?

      retval = nil

      string.each_char do |char|
        if retval
          if CAPS.include?(char)
            retval << "_"
            retval << char.downcase
          else
            retval << char
          end
        else
          retval = char.downcase
        end
      end

      retval
    end

    def underscore_sym(string)
      underscore(string)&.to_sym
    end

    def power_set(array)
      return [[]] if array.empty?

      head, *tail = array
      subsets = power_set(tail)
      subsets + subsets.map { |subset| [head, *subset] }
    end

    def array(object)
      case object
      when nil
        []
      when Array
        object
      else
        [object]
      end
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
        end
      end
    end

    def require_project_file(project, path)
      require_relative("../../#{project}/src/#{path}")
    end

    def symbolize_keys(hash)
      unless all_symbolizable_keys?(hash)
        # :nocov:
        raise "Cannot symbolize keys for #{hash} because they are not all symbolizable"
        # :nocov:
      end

      hash.transform_keys(&:to_sym)
    end

    def symbolize_keys!(hash)
      unless all_symbolizable_keys?(hash)
        # :nocov:
        raise "Cannot symbolize keys for #{hash} because they are not all symbolizable"
        # :nocov:
      end

      hash.transform_keys!(&:to_sym)
    end

    def to_sentence(strings, connector = ", ", last_connector = ", and ")
      return "" if strings.empty?

      *strings, last = strings

      if strings.empty?
        last
      else
        [strings.join(connector), last].join(last_connector)
      end
    end

    def to_or_sentence(strings, connector = ", ")
      to_sentence(strings, connector, ", or ")
    end

    def humanize(string)
      return nil if string.nil?

      if string.is_a?(::Symbol)
        string = string.to_s
      end

      return "" if string.empty?

      string = string.gsub("_", " ")
      string[0] = string[0].upcase

      string
    end

    def deep_dup(object)
      case object
      when ::Array
        object.map { |element| deep_dup(element) }
      when ::Hash
        object.to_h { |k, v| [deep_dup(k), deep_dup(v)] }
      else
        object.dup
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

    def remove_empty(hash)
      hash.reject { |_k, v| (v.is_a?(::Hash) || v.is_a?(::Array)) && v.empty? }
    end

    def remove_blank(hash)
      remove_empty(hash).compact
    end

    def args_and_opts_to_opts(args, opts)
      unless args.is_a?(::Array)
        # :nocov:
        raise ArgumentError, "args must be an array of 0 or 1 hashes but received #{args}"
        # :nocov:
      end

      unless opts.is_a?(::Hash)
        # :nocov:
        raise ArgumentError, "opts must be a hash not a #{opts.class}"
        # :nocov:
      end

      case args.size
      when 0
        opts
      when 1
        arg = args.first

        if opts && !opts.empty?
          unless arg.is_a?(::Hash)
            # :nocov:
            raise ArgumentError, "opts must be a hash not a #{arg.class}"
            # :nocov:
          end

          arg.merge(opts)
        else
          arg
        end
      else
        # :nocov:
        raise ArgumentError, "args must be an array of 0 or 1 hashes but received #{args}"
        # :nocov:
      end
    end

    def arg_and_opts_to_arg(arg, opts)
      if arg && !arg.empty?
        if opts && !opts.empty?
          unless opts.is_a?(::Hash)
            # :nocov:
            raise ArgumentError, "opts must be a hash not a #{opts}"
            # :nocov:
          end

          unless arg.is_a?(::Hash)
            # :nocov:
            raise ArgumentError, "arg must be a hash if present when opts is present"
            # :nocov:
          end

          arg.merge(opts)
        else
          arg
        end
      elsif opts && !opts.empty?
        opts
      end
    end

    # Strange utility method here...
    # idea is there's a method that takes 0 or 1 arguments which may or may not be a hash.
    # To make sure we don't act like there's an argument when there's not or fail to combine
    # parts of the hash that wind up in opts, this method comines it into an array of 0 or 1
    # argument with stuff merged into the argument if needed.
    def args_and_opts_to_args(args, opts)
      unless args.is_a?(::Array)
        # :nocov:
        raise ArgumentError, "args must be an array of 0 or 1 hashes but received #{args}"
        # :nocov:
      end

      case args.size
      when 0
        Util.array(arg_and_opts_to_arg(nil, opts))
      when 1
        # Do not go from 1 argument to 0. ie, [nil] should return [nil] not [].
        if opts && !opts.empty?
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
  end
end
