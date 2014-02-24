# sqitch-postgres

This is used internally at TGI for testing schema changes using [Sqitch][] and
[Postgres][].  It will not work for external use.

The Makefile assumes you already have [Vagrant][] installed as well as the
[sahara][] plugin.  See [Vagrant Downloads][] to install [Vagrant][] and
[Vagrant Plugins Usage][] on install plugins.

I also recommend the [vagrant-vbguest][] plugin.

[Postgres]: http://www.postgresql.org
[Sqitch]: http://sqitch.org
[Vagrant Downloads]: http://www.vagrantup.com/downloads
[Vagrant Plugins Usage]: http://docs.vagrantup.com/v2/plugins/usage.html
[Vagrant]: http://www.vagrantup.com
[sahara]: https://github.com/jedi4ever/sahara
[vagrant-vbguest]: https://github.com/dotless-de/vagrant-vbguest
