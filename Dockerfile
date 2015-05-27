FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y wget nano 
RUN wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb -O /tmp/puppetlabs.deb
RUN dpkg -i /tmp/puppetlabs.deb
RUN apt-get update
RUN apt-get -y install puppetmaster-passenger puppetdb puppetdb-terminus redis-server supervisor net-tools
RUN gem install --no-ri --no-rdoc hiera hiera-puppet redis hiera-redis hiera-redis-backend
RUN apt-get install python-dev python python-pip git uwsgi -y
RUN git clone https://github.com/nedap/puppetboard \
 && cd /puppetboard \
 && pip install -r requirements.txt
RUN apt-get install nginx unicorn -y

ADD supervisor.conf /opt/supervisor.conf
ADD auth.conf /etc/puppet/auth.conf
ADD puppet.conf /etc/puppet/puppet.conf
ADD puppetdb.conf /etc/puppet/puppetdb.conf
ADD jetty.ini /etc/puppetdb/conf.d/jetty.ini
ADD routes.yaml /etc/puppet/routes.yaml
ADD hiera.yaml /etc/hiera.yaml
ADD hiera.yaml /etc/puppet/hiera.yaml
ADD hiera-common.yaml /etc/puppet/hiera/common.yaml
ADD autosign.conf /etc/puppet/autosign.conf
ADD puppetboard-default_settings.py /puppetboard/puppetboard/default_settings.py
ADD nginx.conf /etc/nginx/sites-enabled/default.conf
ADD unicorn.rb /etc/puppet/unicorn.rb
ADD run.sh /usr/local/bin/run

RUN mkdir -p /etc/puppet/environments/default

ENV TERM vt100


EXPOSE 8080 8081 8140 9090
CMD ["/usr/local/bin/run"]
