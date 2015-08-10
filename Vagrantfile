# Author: Andrea Tosatto <andrea.tosy@gmail.com>

### Require plugins
require 'vagrant-hostsupdater'

### Vagrant configuration
Vagrant.configure("2") do |config|

	config.vm.box = 'puppetlabs/centos-7.0-64-puppet'
	config.vm.box_version = '1.0.1'

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

		# VM hostname aliases | Require vagrant-hostsupdater (https://github.com/cogitatio/vagrant-hostsupdater)
		project.hostsupdater.aliases = ["traffico2.dev"]

		### Pass installation procedure over to Puppet (see `manifests/vagrant_mongophp.pp`)
		project.vm.provision :puppet do |puppet|
			puppet.module_path = "modules"
			puppet.manifests_path = "manifests"
			puppet.manifest_file = "vagrant_mongophp.pp"
			puppet.options = [
				'--verbose',
			]
		end

	end

end
