module Foobara
  module Util
    module_function

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

    def all_symbolic_keys?(hash)
      all_symbolic_elements?(hash.keys)
    end

    def all_symbolizable_keys?(hash)
      all_symbolizable_elements?(hash.keys)
    end

    def remove_empty(hash)
      hash.reject { |_k, v| (v.is_a?(::Hash) || v.is_a?(::Array)) && v.empty? }
    end

    def remove_blank(hash)
      remove_empty(hash).compact
    end
  end
end
