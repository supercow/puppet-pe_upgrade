require 'puppet/error'
Puppet::Parser::Functions.newfunction(:pe_pkgname, :type => :rvalue, :doc => <<-EOD
Determine PE package name from facts

Given a set of client facts, determines the name of the pe upgrade package
appropriate for that machine.

Examples
--------

    # On Debian 6 i386
    notice(pe_pkgname('2.6.1'))
    # => notice: Scope(Class[main]): puppet-enterprise-2.6.1-debian-6-i386

    $alternate_facts = {
      architecture      => 'x86_64',
      osfamily          => 'RedHat',
      lsbmajdistrelease => '5',
      operatingsystem   => 'CentOS',
    }

    # Still on Debian 6 i386
    notice(pe_pkgname('2.6.1', $alternate_facts))
    # => notice: Scope(Class[main]): puppet-enterprise-2.6.1-el-5-x86_64

EOD
) do |args|

  unless (1..2).include? args.size
    raise Puppet::Error, "pe_pkgname(): Wrong number of arguments (given #{args.size}, expected 1 or 2)"
  end

  # Unpack and validate PE version
  desired_pe_version = args[0]
  unless desired_pe_version.match /\d+\.\d+\.\d+/
    raise Puppet::Error, "pe_pkgname(): expected a semantic version string matching, got '#{desired_pe_version}'"
  end

  facts = nil
  expected_facts = %w[architecture osfamily operatingsystem lsbmajdistrelease]
  if (manual_facts = args[1])
    facts = manual_facts
  else
    # Look up the required facts from the current scope
    facts = expected_facts.inject({}) do |hash, key|
      hash[key] = lookupvar("::#{key}")
      hash
    end
  end

  # If we've been passed a hash of manual facts, ensure that the provided
  # hash has all the fields we need.
  missing_facts = expected_facts.select { |fact| [nil, :undefined].include? facts[fact] }

  if missing_facts.size > 0
    errmsg  = "pe_pkgname(): facts hash expects keys "
    errmsg << "(#{expected_facts.join(', ')}) to be set;"
    errmsg << " provided facts hash missing (#{missing_facts.join(', ')})"
    raise Puppet::Error, errmsg
  end

  # lazy shorthand for interpolation
  f = facts

  case f['osfamily']
  when 'Windows'
    pkg = 'puppet-enterprise-%s'
  when 'RedHat'
    pkg = "puppet-enterprise-%s-el-#{f['lsbmajdistrelease']}-#{f['architecture']}"
  when 'Debian'
    distro = f['operatingsystem'].downcase
    pkg    = "puppet-enterprise-%s-#{distro}-#{f['lsbmajdistrelease']}-#{f['architecture']}"
  when 'SLES'
    pkg = "puppet-enterprise-%s-sles-11-#{f['architecture']}"
  when 'Solaris'
    pkg = "puppet-enterprise-%s-solaris-10-#{f['architecture']}"
  else
    # Optimistically default to the 'all' tarball
    pkg = 'puppet-enterprise-%s-all'
  end

  pkg % desired_pe_version # Interpolate the version into the filename
end
