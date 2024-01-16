module Foobara
  module Util
    module_function

    def descendants(klass)
      all = Set.new

      klass.subclasses.each do |subclass|
        all << subclass
        all |= descendants(subclass)
      end

      all
    end
  end
end
