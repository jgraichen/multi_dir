require 'tmpdir'

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

    def tempname(prefix_suffix, n = nil)
      join ::Dir::Tmpname.make_tmpname prefix_suffix, n
    end
  end

  ::Pathname.send :include, PathnamePatch
end
