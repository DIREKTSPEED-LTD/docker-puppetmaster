# Puppetmaster

Creates a Puppet Master running with nginx/unicorn, PuppetDB, Dashboard, and Redis (for Hiera).

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

extra code

	# find the name of the puppet master conatiner
	PUPPETMASTER_NAME=$(docker ps | awk '$2 ~ /puppetmaster:latest/ {print $NF}' | cut -d, -f1)

	if [ -z $PUPPETMASTER_NAME ];then
	   echo "Unable to find container tagged with puppetmaster"
	   exit 1
	fi

	# build the agent
	cat Dockerfile-puppetagent | docker build -t puppetagent -

	# Grab the hostname
	HOSTNAME=${1:-ubuntu}
	if [ ${#} -gt 0 ];then
	   shift
	fi

Copy your puppet repo into the puppetmaster
	
    ./copy-puppet-files ~/code/work/puppetcode

    #!/bin/bash

	PUPPET_SRC=${1}

	if [[ -z ${PUPPET_SRC} ]];then
    	echo "Need to provide the local puppet src"
    	exit 1
	fi

	ALREADY_RUNNING=$(
    	docker ps  | awk '$2 ~ /puppet_master:master/ && $0 ~ /puppetmaster/ {print $1}'
	)

	if [[ -z ${ALREADY_RUNNING} ]];then
	    echo "Can't find running puppetmaster"
	    exit 1
	fi

	./docker-cp ${PUPPET_SRC} ${CONTAINER_ID}:/etc/puppet/environments/default/

	echo "restarting puppet-master"
	docker exec -it ${CONTAINER_ID} supervisorctl restart unicorn

Start a puppet agent to connect to your system

	#!/bin/bash

	CLIENT_ID=$(docker run -dt $@ --link puppetmaster:puppetmaster puppet_master:master bash)
	echo 'puppet agent --no-daemonize --server $PUPPETMASTER_PORT_8140_TCP_ADDR --verbose'
	# echo "puppet agent -t --server \$PUPPETMASTER_PORT_8140_TCP_ADDR --certname ${HOSTNAME} --environment git --debug --verbose"
	# docker run -i -t -h ${HOSTNAME} --link=${PUPPETMASTER_NAME}:puppetmaster puppetagent bash
	docker exec -it  ${CLIENT_ID} rm -rf /var/lib/puppet/ssl
	docker exec -it  ${CLIENT_ID} bash

	Start a puppet agent with a node name

    ./start_agent -h hostname_of_client
	# puppet agent --test --server $PUPPETMASTER_PORT_8140_TCP_ADDR

Ports:
------

* 8140 (puppet - SSL)
* 8080 (puppetdb - HTTP)
* 8081 (puppetdb - HTTPS)
* 9091 (puppetboard - HTTP)
