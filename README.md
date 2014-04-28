Docker-Tuleap
==============

This is a simple dockerfile in order to install quickly Tuleap on top of LXC.

How to use it?
---------------

Just install docker on your system as explained on the [docker](http://docker.io) website. Then run:

    $ sudo docker build github.com/vaceletm/docker-tuleap

You just got it!

    $ sudo docker run -d -p 80:80 -p 443:443 docker-tuleap

Will run the container, just open http://localhost and enjoy !

Known issues
------------

* SELinux stuff seems not behaving well (raises errors when trying to install stuff)
* I'm not sure why but supervisord eats 100% of CPU when running by hand. Doesn't seems to be the case when it's run at boot time

Todo
----

* Fix all known issues ;)
* Split the stuff in several images
