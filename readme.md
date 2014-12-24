# Puppetmaster

Creates a Puppet Master running with Apache/Passenger, PuppetDB, Dashboard, and Redis (for Hiera).

What is this ?
--------------

This is a self-contained puppetmaster used for testing and education.

Whats inside ?
--------------

Everything is kept up-to-date during a build.

* Ubuntu
* facter
* hiera
* puppetmaster
** set to autosign everything
* puppet
* puppetdb
* puppetboard
* nginx
* unicorn

How do i play use it ?
----------------------

start the puppet master

    ./up

Copy your puppet repo into the puppetmaster

    ./copy-puppet-files ~/code/work/puppetcode

Start a puppet agent to connect to your system

    ./start_agent
	# puppet agent --test --server $PUPPETMASTER_PORT_8140_TCP_ADDR

Start a puppet agent with a node name

    ./start_agent -h hostname_of_client
	# puppet agent --test --server $PUPPETMASTER_PORT_8140_TCP_ADDR

Ports:
------

* 8140 (puppet - SSL)
* 8080 (puppetdb - HTTP)
* 8081 (puppetdb - HTTPS)
* 9091 (puppetboard - HTTP)
