require 'spec_helper'

describe MultiDir do
  before { MultiDir::Paths.reset_instance }
  before { MultiDir::Paths.load_yaml 'spec/support/multi_dir.yml' }

  it 'should resolve root path' do
    expect(MultiDir.root.to_s).to be == '/usr/lib/myapp'
  end

  it 'should resolve bin path' do
    expect(MultiDir.bin.to_s).to be == '/usr/bin'
  end

  it 'should resolve config path' do
    expect(MultiDir.config.to_s).to be == '/etc/myapp'
  end

  it 'should resolve files path' do
    expect(MultiDir.files.to_s).to be == '/var/files/myapp'
  end

  it 'should resolve tmp path' do
    expect(MultiDir.tmp.to_s).to be == '/tmp/myapp'
  end

  it 'should resolve cache path' do
    expect(MultiDir.cache.to_s).to be == '/var/cache/myapp'
  end

  it 'should resolve custom path' do
    MultiDir::Paths.define :uploads, :in => :files
    expect(MultiDir.uploads.to_s).to be == '/mnt/nfs/storage0/files'
  end

  it 'should resolve quick path' do
    expect(MultiDir.files[:uploads].to_s).to be == '/mnt/nfs/storage0/files'
  end

  it 'should resolve not configured quick path' do
    expect(MultiDir.files[:attachments].to_s).to be == '/var/files/myapp/attachments'
  end

  it 'should allow to glob path' do
    expect(MultiDir.spec_support2.glob('*.yml')).to be == [
        File.expand_path('spec/support/multi_dir_2.yml'),
        File.expand_path('spec/support/multi_dir.yml')
    ]
  end
end
