module Foobara
  module Util
    module_function

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
  end
end
