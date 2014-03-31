# Author: Andrea Tosatto <andrea.tosy@gmail.com>

### Require plugins
require 'vagrant-hostsupdater'

### Vagrant configuration
Vagrant.configure("2") do |config|

	config.vm.box = 'puppetlabs/centos-6.5-x86_64-puppet'
	config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box'

	### VM Virtualbox specs customization
	config.vm.provider "virtualbox" do |v|
		v.name = "Vagrant MongoPHP"
		v.customize ["modifyvm", :id, "--memory", "2048", "--cpus", 2]
	end

	### NFS shared folder | Require nfs-utils  
	config.vm.synced_folder "workspace", "/home/vagrant/workspace", :nfs => true

	### mongophp configuration
	config.vm.define :vagrant_mongophp do |project|

		project.vm.hostname = "mongophp.vagrant.dev"
		project.vm.network :private_network, ip: "33.33.33.20"
		# project.vm.network :public_network, ip: "192.168.1.8"

		# VM hostname aliases | Require vagrant-hostsupdater (https://github.com/cogitatio/vagrant-hostsupdater)
		project.hostsupdater.aliases = ["api.traffico2.dev"]

		### Pass installation procedure over to Puppet (see `manifests/vagrant_mongophp.pp`)
		project.vm.provision :puppet do |puppet|
			puppet.manifests_path = "manifests"
			puppet.module_path = "puppet-modules"
			puppet.manifest_file = "vagrant_mongophp.pp"
			puppet.options = [
				'--verbose',
			]
		end

	end

end
