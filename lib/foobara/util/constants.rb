module Foobara
  EMPTY_ARRAY = [].freeze unless const_defined?(:EMPTY_ARRAY)

  module Util
    EMPTY_ARRAY = Foobara::EMPTY_ARRAY unless const_defined?(:EMPTY_ARRAY)
  end
end
