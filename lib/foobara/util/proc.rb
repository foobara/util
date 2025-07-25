module Foobara
  module Util
    module_function

    def remove_arity_check(lambda)
      arity = lambda.arity

      if arity == 0
        proc { |*, **opts, &block| lambda.call(**opts, &block) }
      else
        proc do |*args, **opts, &block|
          args = args[0...arity]

          remaining = arity - args.size

          if remaining > 0
            args += [nil] * remaining
          end

          lambda.call(*args, **opts, &block)
        end
      end
    end
  end
end
