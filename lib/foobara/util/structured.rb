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

    def deep_symbolize_keys(object)
      case object
      when ::Array
        object.map { |element| deep_symbolize_keys(element) }
      when ::Hash
        object.to_h do |k, v|
          [k.is_a?(::String) ? k.to_sym : k, deep_symbolize_keys(v)]
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
      when ::String
        # Important to not dup ::Module... but going to exclude everything but String for now to prevent that issue
        # and others.
        object.dup
      else
        object
      end
    end
  end
end
