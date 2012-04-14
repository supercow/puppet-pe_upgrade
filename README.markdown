Puppet Enterprise Upgrade Module
================================

This module will upgrade Puppet Enterprise.

Required modules
----------------

You will need hiera installed to use this module. Hiera has been added to PE
as of version 2.5.0; so you can upgrade your master to get it. If this isn't
an option, you can use the [puppet-hiera][puppet-hiera] module. You'll also
need a functioning hiera installation for this to work; you can use the
aforementioned hiera module to set up a basic configuration.

[puppet-hiera]: https://github.com/nanliu/puppet-hiera "Puppet module to install hiera"

The puppet-staging module is a prerequisite for this module. You can find it at
the following locations:

  * Puppet Forge: http://forge.puppetlabs.com/nanliu/staging
  * Github: https://github.com/nanliu/puppet-hiera

Usage
-----

### Downloading PE from puppetlabs.com

The simplest use of this class downloads the installer from the Puppet Labs
servers.

    include pe_upgrade

- - -

You can also locally host the downloads to conserve bandwidth and speed up
deployment time.

### Hosting the installer on the master

To cut down on size, the Puppet Enterprise installer is not included. You will
need to download 'puppet-enterprise-${version}-all.tar.gz' and place it in
'pe/files'.

You can use the following class definition to pull the download from the
Puppet Labs download server.


    class { 'pe_upgrade':
      version      => '2.5.0',
      answersfile  => "pe/answers/agent.txt.erb",
      download_dir => 'puppet:///site-files/pe/2.0.3',
      timeout      => '3600',
    }

### Hosting the installer on a web server

In this example, download 'puppet-enterprise-${version}-all.tar.gz' and place
it on your webserver.

    class { 'pe_upgrade':
      version      => '2.5.0',
      answersfile  => "pe/answers/agent.txt.erb",
      download_dir => 'http://site.downloads.local/pe/2.0.3',
      timeout      => '3600',
    }

Deploying the module from Puppet Dashboard
------------------------------------------

You can use Puppet Dashboard to configure this module. Since Puppet Dashboard
doesn't directly support parameterized classes, you can use global variables
to configure the module. See the data.pp class documentation for all respected
variables.

Answers Templates
-----------------

A default answers file is available at templates/answers/default-agent.txt.erb.
It's recommended that you upgrade the master by hand, since that will provide
hiera for you, and since 2.5.0 has some new very site specific questions due
to the console auth component, it's not really possible to provide a generic
answers file.

See Also
--------

Please view the documentation in the enclosed manifests specific descriptions
and usage.

Caveats
-------

This module needs to download the universal installer on every node; this will
be fixed in later releases.

Due to the complexity of upgrading masters, using this module to upgrade a
master is possible but not supported out of the box; you'll have to supply
your own answers file.
