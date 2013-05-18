require 'active_support/core_ext/hash/keys'

require 'multi_dir/version'
require 'multi_dir/paths'
require 'multi_dir/pathname_patch'

module MultiDir
  class << self
    def define_path_method(name)
      name = name.to_sym
      singleton_class.instance_eval do
        define_method(name) { self.resolve name }
      end
    end

    def [](symbol)
      Pathname.new MultiDir::Paths.instance.resolve symbol
    end
    alias_method :resolve, :[]
  end

  [ :root, :bin, :lib, :tmp, :config, :cache, :files ].each do |path|
    define_path_method path
  end
end
