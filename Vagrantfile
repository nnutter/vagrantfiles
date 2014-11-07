# -*- mode: ruby -*-
# vim: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Runs `apt-get update` if it's been "more than a day".
    config.vm.provision 'shell',
        :inline => "find /var/lib/apt/lists -maxdepth 0 -mtime +1 -exec apt-get update -qq \\;"

    config.vm.network "private_network", ip: "192.168.50.50"

    config.vm.provision 'puppet' do |puppet|
        puppet.options = '--environment vagrant --verbose'
        puppet.module_path   = 'modules'
        puppet.manifests_path = '.'
        puppet.manifest_file = 'Vagrantfile.pp'
    end

    config.vm.box = 'genome/ubuntu-precise-puppet'
end
