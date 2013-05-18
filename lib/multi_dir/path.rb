module MultiDir

  # Provide additional function to operate
  # on directories.
  #
  class Path < Pathname

    def glob(pattern)
      Dir.glob File.join(to_s, pattern)
    end

    def [](path)
      if MultiDir::Paths.instance.paths.include? path.to_sym
        return MultiDir::Paths.instance.resolve(path)
      end

      join path.to_s
    end
  end
end
