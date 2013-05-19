module MultiDir

  # Provide additional function to operate
  # on directories.
  #
  module PathnamePatch

    def glob(*patterns)
      Dir.glob File.join(to_s, *patterns)
    end

    def [](path)
      if MultiDir::Paths.instance.paths.include? path.to_sym
        return MultiDir::Paths.instance.resolve(path)
      end

      join path.to_s
    end
  end

  ::Pathname.send :include, PathnamePatch
end
