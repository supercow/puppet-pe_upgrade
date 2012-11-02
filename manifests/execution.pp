class pe_upgrade::execution($timeout, $logfile) {

  include pe_upgrade
  # These variables are not passed as parameters because they have to remain
  # constant and should not be tuned. Private variables, if you will.
  $mode         = $pe_upgrade::mode
  $staging_root = $pe_upgrade::staging_root
  $answersfile  = $pe_upgrade::answersfile

  $bin = $mode ? {
    'install' => 'puppet-enterprise-installer',
    default   => 'puppet-enterprise-upgrader',
  }

  if $logfile { $log_directive = "-l ${logfile}" }
  else        { $log_directive = "" }

  $cmd = "${staging_root}/${installer_dir}/${bin}"
  $validate_cmd = "${cmd} -n -a ${answersfile_dest}"
  $run_cmd      = "${cmd} ${log_directive} -a ${answersfile_dest}"

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
    command   => $validate_cmd,
    path      => $exec_paths,
    user      => 0,
    group     => 0,
    logoutput => on_failure,
    timeout   => $timeout,
    require   => File[$answersfile_dest],
  }

  exec { 'Run upgrade':
    command   => $run_cmd,
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
