class pe_upgrade::execution($timeout) {

  include pe_upgrade
  # These variables are not passed as parameters because they have to remain
  # constant and should not be tuned. Private variables, if you will.
  $mode         = $pe_upgrade::mode
  $staging_root = $pe_upgrade::staging_root
  $answersfile  = $pe_upgrade::answersfile

  $execute = $mode ? {
    'install' => "${staging_root}/${installer_dir}/puppet-enterprise-installer",
    default   => "${staging_root}/${installer_dir}/puppet-enterprise-upgrader",
  }

  $exec_paths = [
    '/usr/bin',
    '/bin',
    '/usr/local/bin',
    '/usr/sbin',
    '/sbin',
    '/usr/local/sbin'
  ]

  # These values are supplied to the answersfile template.
  $certname     = $pe_upgrade::certname
  $server       = $pe_upgrade::server

  $answersfile_dest = "${staging_root}/answers.txt"
  file { $answersfile_dest:
    ensure  => present,
    content => template($answersfile),
    owner   => 0,
    group   => 0,
  }

  exec { 'Validate answers':
    command   => "${execute} -n -a ${answersfile_dest}",
    path      => $exec_paths,
    user      => 0,
    group     => 0,
    logoutput => on_failure,
    timeout   => $timeout,
    require   => File[$answersfile_dest],
  }

  exec { 'Run upgrade':
    command   => "${execute} -a ${answersfile_dest}",
    path      => $exec_paths,
    user      => 0,
    group     => 0,
    logoutput => on_failure,
    timeout   => $timeout,
    require   => Exec['Validate answers'],
  }

  ############################################################################
  # If running in install mode, then shut down Puppet Open Source after install
  # Don't actually remove it. Let the user define that strategy
  ############################################################################
  if $mode == 'install' {
    service { 'puppet':
      ensure  => stopped,
      enable  => false,
      require => Exec['Run upgrade'],
    }
  }
}
