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
      join mktmpname prefix_suffix, n
    end

    private
    def mktmpname(prefix_suffix, n = nil)
      case prefix_suffix
        when Array
          prefix = prefix_suffix[0].to_s
          suffix = prefix_suffix[1].to_s
        else
          prefix = prefix_suffix.to_s
      end
      t = Time.now.strftime("%Y%m%d")
      path = "#{prefix}#{t}-#{$$}-#{rand(0x100000000).to_s(36)}"
      path << "-#{n}" if n
      path << suffix  if suffix
      path
    end
  end

  ::Pathname.send :include, PathnamePatch
end
