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
  end
end
