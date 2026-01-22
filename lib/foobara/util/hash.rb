module Foobara
  module Util
    module_function

    def sort_by_keys(hash)
      keys = hash.keys

      keys.sort!

      sorted_hash = {}

      keys.each do |key|
        sorted_hash[key] = hash[key]
      end

      sorted_hash
    end

    def sort_by_keys!(hash)
      last_key = keys_to_move = nil

      hash.each_key do |key|
        if last_key
          if key < last_key
            if keys_to_move
              keys_to_move << key
            else
              keys_to_move = [key]
            end

            next
          end
        end

        last_key = key
      end

      return hash unless keys_to_move

      keys_to_move.sort!

      keys_to_move.each do |key|
        value = hash.delete(key)
        hash[key] = value
      end

      hash
    end

    def symbolize_keys(hash)
      unless all_symbolizable_keys?(hash)
        # :nocov:
        raise "Cannot symbolize keys for #{hash} because they are not all symbolizable"
        # :nocov:
      end

      unless hash.instance_of?(::Hash)
        unless hash.respond_to?(:to_h)
          # :nocov:
          raise ArgumentError, "Could not turn #{hash} into an instance of Hash"
          # :nocov:
        end

        hash = hash.to_h
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

      unless hash.instance_of?(::Hash)
        unless all_symbolic_keys?(hash)
          raise ArgumentError, "Cannot symbolize keys for #{hash} because it isn't behaving like a Hash"
        end
      end

      hash
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
