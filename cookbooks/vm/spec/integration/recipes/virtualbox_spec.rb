require 'spec_helper'

describe 'vm::virtualbox' do

  let(:virtualbox_version) { vm_user_command('vboxmanage --version').stdout.strip }

  it 'installs VirtualBox 5.1.22' do
    expect(virtualbox_version).to match '5.1.22'
  end
end
