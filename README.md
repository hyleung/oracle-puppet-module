Oracle XE 11g Module
=================

This project is a Puppet module for provisioning an Oracle XE 11g database into an Ubuntu 11.10 64bit server. The project does **not** include the actual RPM for Oracle XE 11g - you'll have to download the zip file containing the RPM from the Oracle [website](http://www.oracle.com/technetwork/products/express-edition/downloads/index.html?origref=http://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm) and place it in the *files* folder.

So far, this module has only been tested on Ubuntu 11.10 64bit. 

Credits
-------
* Most of the *really* tricky stuff was forked off of [this](https://github.com/codescape/vagrant-oracle-xe) repository.
