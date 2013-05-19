require 'spec_helper'

describe MultiDir::PathnamePatch do
  before { MultiDir::Paths.load_yaml 'spec/support/multi_dir.yml' }

  describe '#[]' do
    context 'with not configured semantic path' do
      it 'should return joined path' do
        expect( MultiDir.tmp[:not_configured_sym].to_s ).to be == '/tmp/myapp/not_configured_sym'
      end
    end

    context 'with configured semantic path' do
      it 'should return configured path' do
        expect( MultiDir.tmp[:uploads].to_s ).to be == '/mnt/nfs/storage0/files'
      end
    end
  end

  describe 'glob' do
    it 'should glob directory with joined pattern' do
      Dir.should_receive(:glob).with('/tmp/myapp/path/**/*.rb').and_return(%w(a.rb b.rb))

      expect( MultiDir.tmp.glob 'path', '**', '*.rb' ).to be == %w(a.rb b.rb)
    end
  end
end
