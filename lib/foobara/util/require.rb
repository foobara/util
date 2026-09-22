module Foobara
  module Util
    module_function

    def require_directory(directory)
      require_pattern("#{directory}/**/*.rb")
    end

    def require_pattern(glob)
      files = Dir[glob]

      if files.empty?
        # simplecov:disable
        raise "Didn't find anything to require for #{glob}"
        # simplecov:enable
      end

      files.sort_by { |file| [file.count("/"), file.length, file] }.reverse.each do |f|
        require f
      end
    end
  end
end
