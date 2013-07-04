# Authors: Andrea Sosso   <andrea@sosso.me>
#          Andrea Tosatto <andrea.tosy@gmail.com>

Exec {
	path => ['/usr/local/bin/:/bin/:/usr/bin/'],
}

### Users
user {
	'vagrant':
		ensure  => present,
		groups  => ['nginx'],
		require => Package['nginx'],
		notify  => [Service["nginx"], Service["php-fpm"]]; 

	'nginx':
		ensure  => present,
		groups  => ['vagrant'],
		require => Package['nginx'],
		notify  => [Service["nginx"], Service["php-fpm"]];
}

### Directories
file {
	"/home/vagrant":
		ensure => "directory",
		mode   => 755;

	"/home/vagrant/tmp":
		ensure  => "directory",
		mode    => 777,
		require => File["/home/vagrant"];

	"/home/vagrant/logs":
		ensure  => "directory",
		mode    => 700,
		require => File["/home/vagrant"];
}

### Setting up the yum repo and packages
class {
	'yum':
		extrarepo => ['nginx', 'remi', 'remi-test', 'epel'],	 
}

### Nginx
package {
	"nginx":
		require => Class['yum::repo::nginx'],
}

service {
	"nginx":
		enable  => true,
		ensure  => "running",
		require => Package['nginx'],
}

file {
	'/etc/nginx/nginx.conf':
		ensure  => file,
		mode    => 600,
		source  => 'puppet:///modules/config-files/nginx.conf',
		require => Package['nginx'],
		notify  => Service["nginx"], 
}

### Mongodb
class { "mongodb": }

### PHP-FPM
package {
	'php-fpm':
		ensure => installed, 
		require => Class['yum::repo::remi'],
}

package {
	["php-common", "php", "php-pecl-apc", "php-pecl-xdebug", "php-cli", "php-pear", "php-pecl-mongo", "php-pdo", "php-gd", "php-mbstring", "php-xml", "php-imap", "php-mcrypt", "mcrypt", "php-intl", "php-devel", "php-soap"]: 
		ensure => installed,
		require => [Package['php-fpm'], Class['yum::repo::epel']],
}

service {
	'php-fpm': 
		enable  => true,
		ensure  => "running",
		require => Package['php-fpm'],
}

file {
	'/etc/php-fpm.d/vagrant.pool.conf':
		ensure	=> file,
		mode	=> 600,
		source	=> 'puppet:///modules/config-files/vagrant.pool.conf',
		require	=> Package['php-fpm'],
		notify  => Service["php-fpm"], 
}

file {
	'/etc/php.ini':
		ensure	=> file,
		mode	=> 600,
		source	=> 'puppet:///modules/config-files/php.ini',
		require	=> Package['php-fpm'],
		notify  => Service["php-fpm"], 
}

### NFS
package {
	'nfs-utils':
		ensure  => installed,
}

### GCC
package {
	"gcc-c++":
		ensure => "installed",
}

### Java
package {
	'java-1.7.0-openjdk':
		ensure	=> installed,
		require	=> Class['yum'],
}

### Others Packages
package {
	['nano', 'vim-enhanced', 'yum-utils', 'mlocate', 'git', 'curl', 'subversion']:
		ensure => installed, 
}

### Install of composer.phar in /bin
exec { 
	"install_composer":
		command => "curl -s https://getcomposer.org/installer | php -- --install-dir=/bin",
		require => [Package['curl'], Package['php']],
		creates => "/bin/composer.phar",
}

### Install of phpunit.phar in /usr/bin
exec { 
	"install_phpUnit":
		command => "wget --output-document=/usr/bin/phpunit.phar http://pear.phpunit.de/get/phpunit.phar && chmod +x /usr/bin/phpunit.phar",
		require => [Package['php'], Package['php-pear']],
		creates => "/usr/bin/phpunit.phar",
}

### Welcome messages
host {
	'self':
		ensure => present,
		name => $fqdn,
		host_aliases => [$hostname], ip => $ipaddress,
}

file {
	'motd':
		ensure => file,
		path => '/etc/motd',
		mode => 0644,
		content => "\n***** Vagrant Development VM ****\n\n\nOS:\t\t${operatingsystem} ${operatingsystemrelease}\nHOSTNAME:\t${fqdn}\nPUBLIC IP:\t${ipaddress_eth1}\n\n\n",
}

### Security Config
case $operatingsystem {

		centos: {

				package {
					['bind-utils']: 
						ensure => installed,
				}

				file { 
					"/etc/selinux/config":
						ensure  => file,
						source  => 'puppet:///modules/config-files/selinux.cfg',
						owner   => root,
						group   => root,
						notify  => Exec["disable_selinux"], 
				}

				exec { 
					"disable_selinux":
						command      => "setenforce 0",
						refreshonly  => true,
						path         => "/usr/sbin";

						"disable_iptables":
							command => "sudo iptables --flush";
				}

		} # end centos configurations

} # end case