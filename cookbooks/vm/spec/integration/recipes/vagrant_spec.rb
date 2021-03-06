require 'spec_helper'

describe 'vm::vagrant' do

  let(:vagrant_version) { vm_user_command('vagrant -v').stdout.strip }
  let(:installed_plugins) { vm_user_command('vagrant plugin list').stdout }

  it 'installs vagrant 1.9.5' do
    expect(vagrant_version).to match 'Vagrant 1.9.5'
  end

  if in_vmware?
    it 'configures "virtualbox" as the $VAGRANT_DEFAULT_PROVIDER on VMware platforms' do
      expect(vm_user_command('echo $VAGRANT_DEFAULT_PROVIDER').stdout.strip).to eq 'virtualbox'
    end
  else
    it 'configures "docker" as the $VAGRANT_DEFAULT_PROVIDER on non-VMware platforms' do
      expect(vm_user_command('echo $VAGRANT_DEFAULT_PROVIDER').stdout.strip).to eq 'docker'
    end
  end

  describe 'plugins' do
    it 'installs "vagrant-cachier" plugin v1.2.1' do
      expect(installed_plugins).to include 'vagrant-cachier (1.2.1)'
    end
    it 'installs "vagrant-berkshelf" plugin v5.1.1' do
      expect(installed_plugins).to include 'vagrant-berkshelf (5.1.1)'
    end
    it 'installs "vagrant-omnibus" plugin v1.5.0' do
      expect(installed_plugins).to include 'vagrant-omnibus (1.5.0)'
    end
    it 'installs "vagrant-toplevel-cookbooks" plugin v0.2.4' do
      expect(installed_plugins).to include 'vagrant-toplevel-cookbooks (0.2.4)'
    end
    it 'installs "vagrant-managed-servers" plugin v0.8.0' do
      expect(installed_plugins).to include 'vagrant-managed-servers (0.8.0)'
    end
    it 'installs "vagrant-lxc" plugin v1.2.3' do
      expect(installed_plugins).to include 'vagrant-lxc (1.2.3)'
    end
  end
end
