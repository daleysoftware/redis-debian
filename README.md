Redis-Debian
============

Tools to build a lightweight debian package for customized redis builds.

The custom debian produced by the scripts in this repo is very lightweight and features very reliable upstart-based service management. The redis-server service will be started on installation of this package.

Usage
=====

    ./build-redis-debian.sh <name> <version> <desc> <repo>

Where

* name = the control name for the debian.
* debian = the version of the debian.
* desc = text that will be appended to the control description.
* repo = the directory where your redis repo is located.
