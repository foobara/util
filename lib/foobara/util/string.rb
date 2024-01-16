module Foobara
  module Util
    module_function

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

    IS_CAP = /[A-Z]/
    IS_IDENTIFIER_CHARACTER = /\w/

    def constantify(string)
      return nil if string.nil?

      if string.is_a?(::Symbol)
        string = string.to_s
      end

      if string.chars.all? { |char| IS_CAP =~ char }
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

      retval = ""
      is_start = true

      string.each_char do |char|
        if IS_IDENTIFIER_CHARACTER =~ char
          if IS_CAP =~ char
            char = char.downcase
            char = "_#{char}" unless is_start
          end

          is_start = false
        else
          is_start = true
        end

        retval << char
      end

      retval
    end

    def underscore_sym(string)
      underscore(string)&.to_sym
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
  end
end
