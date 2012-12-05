# Funziona solo su Linux o MacOS X con vagrant-hostmaster installato sulla macchina host
# e nfs-utils installato sulla macchina guest. nfs-utils viene installato automaticamente
# da puppet durante il primo provisioning.
#
# Per installare vagrant-hostmaster: 
#		vagrant gem install vagrant-hostmaster
#
# Author: Andrea Sosso <andrea@sosso.me>

Vagrant::Config.run do |config|
    config.vm.box = 'centos-63-64-puppet'
    config.vm.box_url = 'https://tekarea.it/dev/vagrant/centos-6.3-64bit-puppet-vbox.4.2.4.box'
    
    ### Condivisione cartelle NFS (veloce) | Richiede nfs-utils  
    config.vm.share_folder("v-data", "/home/vagrant/data", "data", :nfs => true, :extra => 'dmode=777,fmode=777')
    
    ### Abilita l'interfaccia grafica
    # config.vm.boot_mode = :gui

	### Configurazione per VirtualBox lente
	config.ssh.max_tries = 50
 	config.ssh.timeout   = 300
	
	### Configurazione port forwarding
	# config.vm.forward_port 3306, 3306
	
	### Puppet configuration
    config.vm.define :project do |project_config|
        project_config.vm.host_name = "centos.tekarea.dev"
		project_config.hosts.name = "pma.dev centos.tekarea.dev"

        project_config.vm.network :hostonly, "33.33.33.10"

        ### Pass installation procedure over to Puppet (see `manifests/project.pp`)
        project_config.vm.provision :puppet do |puppet|
            puppet.manifests_path = "manifests"
            puppet.module_path = "puppet-modules"
            puppet.manifest_file = "project.pp"
            puppet.options = [
                '--verbose',
            ]
        end
    end
end
