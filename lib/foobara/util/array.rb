module Foobara
  module Util
    module_function

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

    def all_symbolic_elements?(array)
      array.all? { |key| key.is_a?(Symbol) || key.is_a?(String) }
    end

    def all_symbolizable_elements?(array)
      array.all? { |key| key.is_a?(Symbol) || key.is_a?(String) }
    end

    def all_blank_or_false?(array)
      array.all? do |element|
        element.nil? || element == false || (
          (element.is_a?(::Hash) || element.is_a?(::Array) || element.is_a?(::String)) && element.empty?
        )
      end
    end

    def start_with?(large_array, small_array)
      return false unless large_array.size >= small_array.size

      small_array.each.with_index do |item, index|
        return false unless large_array[index] == item
      end

      true
    end
  end
end
