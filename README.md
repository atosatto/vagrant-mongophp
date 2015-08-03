vagrant-mongophp
===========

Vagrant VirtualMachine providing a Centos 6.3 + Nginx + MongoDB + PHP webapp development stack.

Installation
------------
First of all be sure to have installed on your host machine the latest versions of [Virtualbox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/).

Install the vagrant-hostsupdater plugin with

	vagrant plugin install vagrant-hostsupdater

Then, clone this project with:

	git clone https://github.com/hilbert-/vagrant-mongophp.git

The puppet modules are handled with [librarian-puppet](http://librarian-puppet.com/).
Install it with

	gem install librarian-puppet

Finally, download the required modules with

	librarian-puppet install

Usage
-----

You can startup the VM with

	vagrant up

If you see an error similar to this one

	[vagrant_web] Mounting NFS shared folders...
	The following SSH command responded with a non-zero exit status.
	Vagrant assumes that this means the command failed!

	mount -o vers=3 33.33.33.1:'/Users/andrea/Documents/Sviluppo/vagrant-vms/vagrant-webmongo/data' /home/vagrant/data

you have to execute

	vagrant provision
	vagrant reload

since it is caused by the fact that nfs is not installed on the virtual machine.
This will be installed during the provisioning.

To share folders or files with the VM you have simply to put them into the `<vagrant-web-path>/data`. In fact this directory is mounted via NFS on the `/home/vagrant/data` directory of the VM.

Contribute
----------
Contributions are welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
