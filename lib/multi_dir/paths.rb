require 'yaml'

module MultiDir

  # Can resolve paths using symbols.
  #
  class Paths

    def initialize(paths = {})
      self.paths.merge! paths.symbolize_keys unless paths.nil? or paths.empty?
    end

    # Resolve symbolic path to real path.
    #
    def resolve(symbol)
      case symbol
        when :root
          resolve_root
        else
          raise ArgumentError.new "Path symbol `#{symbol.inspect}` does not exist." unless paths.has_key? symbol

          path = paths[symbol]
          if path.is_a? Array
            File.join resolve(path[0]), path[1].to_s
          else
            path.to_s
          end
      end
    end

    # Resolve root path.
    #
    def resolve_root
      return paths[:root] if paths.has_key? :root
      return ::Rails.root.to_s if Object.const_defined?(:Rails) && ::Rails.respond_to?(:root)
      Pathname.pwd.to_s
    end

    def paths
      @paths ||= load_paths
    end

    def load_paths
      paths = default_paths

      [ 'multi_dir.yml', ENV['MULTI_DIR_CONFIG'] ].reject(&:nil?).each do |file|
        next unless File.exists? file
        paths.merge! load_yaml file
      end

      paths
    end

    def default_paths
      {
          :bin    => [:root, 'bin'],
          :lib    => [:root, 'lib'],
          :tmp    => [:root, 'tmp'],
          :cache  => [:tmp, 'cache'],
          :config => [:root, 'config'],
          :files  => [:root, 'files']
      }
    end

    def load_yaml(file)
      raise ArgumentError.new "File `#{file}` does not exists." unless File.exists? file
      raise ArgumentError.new "File `#{file}` is not readable." unless File.readable? file
      data = YAML.load_file(file).symbolize_keys

      unless data.is_a? Hash and data.has_key? :paths
        raise ArgumentError.new "File `#{file}` does not contain a valid MultiDir YAML definition."
      end

      data[:paths].inject({}) do |memo, row|
        key, path = row[0].to_sym, row[1].to_s
        memo[key] = if %w(/ .).include? path[0].chr
          File.expand_path path.to_s
        else
          [ :root, path.to_s ]
        end

        memo
      end
    end

    def load_yaml!(file)
      paths.merge! load_yaml file
    end

    def define(name, options = {})
      name = name.to_s

      if MultiDir.methods.include?(name)
        raise ArgumentError.new "Path name `#{name}` would override already defined method on MultiDir."
      end

      parent = options[:id] || options[:parent]
      paths[name] = [ parent, name.to_s ]

      MultiDir.define_path_method name
    end

    class << self

      def instance
        @instance ||= new
      end

      def reset_instance
        @instance = nil
      end

      def load_yaml(file)
        instance.load_yaml! file
      end

      # Define a new semantic path.
      #
      def define(name, options = {})
        instance.define name, options
      end
    end
  end
end
