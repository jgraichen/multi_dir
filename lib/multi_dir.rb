require 'active_support/core_ext/hash/keys'

require 'multi_dir/version'
require 'multi_dir/paths'
require 'multi_dir/pathname_patch'

module MultiDir
  class << self

    def method_missing(name, *_)
      Pathname.new MultiDir::Paths.instance.resolve name
    end
  end
end
