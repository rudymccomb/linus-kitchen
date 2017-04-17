
vagrant_version = '1.9.3'
vagrant_deb_file = "vagrant_#{vagrant_version}_x86_64.deb"
vagrant_checksum = 'faff6befacc7eed3978b4b71f0dbb9c135c01d8a4d13236bda2f9ed53482d2c4'

vagrant_plugins = {
  'vagrant-cachier' => '1.2.1',
  'vagrant-berkshelf' => '5.1.1',
  'vagrant-omnibus' => '1.5.0',
  'vagrant-toplevel-cookbooks' => '0.2.4',
  'vagrant-managed-servers' => '0.8.0',
  'vagrant-lxc' => '1.2.3'
}

# download and install vagrant
remote_file "#{Chef::Config[:file_cache_path]}/#{vagrant_deb_file}" do
  source "https://releases.hashicorp.com/vagrant/#{vagrant_version}/#{vagrant_deb_file}"
  checksum vagrant_checksum
  notifies :install, 'dpkg_package[vagrant]', :immediately
end
dpkg_package 'vagrant' do
  source "#{Chef::Config[:file_cache_path]}/#{vagrant_deb_file}"
  version vagrant_version
end

# install vagrant plugins
vagrant_plugins.each do |name, version|
  install_vagrant_plugin(name, version)
end

# set default provider
bashd_entry 'set-vagrant-default-provider' do
  user vm_user
  content "export VAGRANT_DEFAULT_PROVIDER=#{vmware? ? 'virtualbox' : 'docker'}"
end

#
# vagrant-lxc setup
#
%w(lxc lxc-templates cgroup-lite redir bridge-utils).each do |pkg|
  package pkg
end
bash 'add vagrant-lxc sudoers permissions' do
  environment vm_user_env
  code 'vagrant lxc sudoers'
  not_if { ::File.exist? '/etc/sudoers.d/vagrant-lxc' }
end

#
# tricks to make vagrant-cachier kick in during test-kitchen runs
#
template "#{vm_userhome}/.vagrant.d/Vagrantfile" do
  source 'Vagrantfile.erb'
  owner vm_user
  group vm_group
  mode '0644'
end
directory "#{vm_userhome}/.kitchen" do
  owner vm_user
  group vm_group
  mode '0755'
end
template "#{vm_userhome}/.kitchen/config.yml" do
  source 'kitchen_config.erb'
  owner vm_user
  group vm_group
  mode '0644'
end
