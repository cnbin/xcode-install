require File.expand_path('../spec_helper', __FILE__)

module XcodeInstall
  describe Command::Install do
    before do
      Installer.any_instance.stubs(:exists).returns(true)
      Installer.any_instance.stubs(:installed).returns([])
      fixture = Pathname.new('spec/fixtures/xcode_63.json').read
      xcode = Xcode.new(JSON.parse(fixture))
      Installer.any_instance.stubs(:seedlist).returns([xcode])
    end

    it 'downloads and installs' do
      Installer.any_instance.expects(:download).with('6.3', true).returns('/some/path')
      Installer.any_instance.expects(:install_dmg).with('/some/path', '-6.3', true, true)
      Command::Install.run(['6.3'])
    end

    it 'downloads and installs and does not switch if --no-switch given' do
      Installer.any_instance.expects(:download).with('6.3', true).returns('/some/path')
      Installer.any_instance.expects(:install_dmg).with('/some/path', '-6.3', false, true)
      Command::Install.run(['6.3', '--no-switch'])
    end

    it 'downloads without progress if switch --no-progress is given' do
      Installer.any_instance.expects(:download).with('6.3', false).returns('/some/path')
      Installer.any_instance.expects(:install_dmg).with('/some/path', '-6.3', true, true)
      Command::Install.run(['6.3', '--no-progress'])
    end
  end
end
