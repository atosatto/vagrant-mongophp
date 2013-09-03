# Author: Andrea Tosatto <andrea.tosy@gmail.com>

Vagrant.require_plugin('vagrant-hostsupdater')

Vagrant.configure("2") do |config|

	config.vm.box = 'centos-64-x64-puppet'
	config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box'

	### VM Specs customization
	# config.vm.customize ["modifyvm", :id, "--memory", 2048, "--cpus", 2]

	### NFS shared folder | Require nfs-utils  
	config.vm.synced_folder "data", "/home/vagrant/data", :nfs => true, :extra => 'dmode=777,fmode=777'

	### Needed by slow Virtualbox installations
	# config.ssh.max_tries = 50
	# config.ssh.timeout   = 300

	### Puppet configuration
	config.vm.define :vagrant_mongophp do |project|

		project.vm.hostname = "mongophp.vagrant.dev"
		project.vm.network :private_network, ip: "33.33.33.20"
		# project.vm.network :public_network, ip: "192.168.1.8"

		# VM hostname aliases | Require vagrant-hostsupdater (https://github.com/cogitatio/vagrant-hostsupdater)
		project.hostsupdater.aliases = ["maps.traffico2.dev", "api.traffico2.dev"]

		### Pass installation procedure over to Puppet (see `manifests/project.pp`)
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
