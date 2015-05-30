FROM ubuntu:14.04
ENV TERM vt100
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

COPY root /

EXPOSE 8080 8081 8140 9090
CMD ["/usr/local/bin/run"]
