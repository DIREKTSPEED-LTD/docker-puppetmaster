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
* puppet
* puppetdb
* puppetboard
* nginx
* unicorn

How do i play use it ?
----------------------

```
./up
```


How do i play use it ?
----------------------

Build

```
docker build -t puppetmaster .
```

Note: you can trigger the puppetmaster to run the puppet agent is...

```
puppet agent -t`
```

Ports:
------

* 8140 (puppet - SSL)
* 8080 (puppetdb - HTTP)
* 8081 (puppetdb - HTTPS)
* 9091 (puppetboard - HTTP)
