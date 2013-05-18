require 'spec_helper'

describe MultiDir::Paths do
  let(:config) { nil }
  let(:paths)  { MultiDir::Paths.new config }

  describe '#load_paths' do
    context 'with local file' do
      it 'should load local configuration' do
        Dir.chdir 'spec/support' do
          expect(paths.resolve :root).to be == '/usr/lib/myapp'
        end
      end
    end
  end

  describe '#load_yaml' do
    let(:cfg) { paths.load_yaml 'spec/support/multi_dir.yml' }

    it 'should load configuration from YAML file' do
      expect(cfg).to include(:root, :bin, :cache, :config, :tmp, :files, :uploads)
    end

    it 'should detect absolute paths' do
      expect(cfg[:bin]).to be == '/usr/bin'
    end

    it 'should detect relative paths' do
      expect(cfg[:spec_support]).to be == [ :root, 'spec/support' ]
    end

    it 'should detect working dir relative path' do
      expect(cfg[:spec_support2]).to be == Pathname.pwd.join('spec/support').to_s
    end
  end

  describe '#resolve' do
    let(:config) { { :root => '/root', :tmp => [:root, 'tmp'] } }

    it 'should resolve direct path symbol' do
      expect(paths.resolve :root).to be == '/root'
    end

    it 'should resolve indirect path symbol' do
      expect(paths.resolve :tmp).to be == '/root/tmp'
    end

    it 'should raise error on not existing path symbols' do
      expect {
        paths.resolve :not_existing_symbol
      }.to raise_error(ArgumentError)
    end
  end

  describe '#resovle_root' do
    context 'with configure root path' do
      let(:config) { { :root => '/var/app/root' } }

      it 'should resolve to configured root path' do
        expect(paths.resolve_root).to be == '/var/app/root'
      end
    end

    context 'with not configured path but loaded Rails app' do
      before { module ::Rails; def self.root; Pathname.new 'app'; end end }
      after  { Object.send :remove_const, :Rails }

      it 'should resolve to Rails root' do
        puts Rails.root
        expect(paths.resolve_root).to be == 'app'
      end
    end

    context 'without configured path and rails root' do
      it 'should resolve to current working dir' do
        expect(paths.resolve_root).to be == Pathname.pwd.to_s
      end
    end
  end
end
