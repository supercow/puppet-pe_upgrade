# This class exists to fail.
class pe_upgrade::validation {

  include pe_upgrade
  $force_upgrade = $pe_upgrade::force_upgrade

  if $::osfamily == 'Windows' {
    fail("osfamily 'Windows' is not currently supported")
  }

  if $::fact_is_puppetmaster == 'true' and ! $force_upgrade {
    fail("Refusing to upgrade Puppet master ${::clientcert} without 'force_upgrade' set")
  }

  # Perform version validation
  $ver_split = split($version, '\.')
  $desired_major_version = $ver_split[0]
  $desired_minor_version = $ver_split[1]
  $desired_patch_version = $ver_split[2]

  # If someone really really wants to force a downgrade, I respect their
  # decisions and trust they understand the implication of their actions.
  if ! $force_upgrade {
    $errmsg = "Refusing to downgrade from ${::pe_version} to ${version} without 'force_upgrade' set"
    if $desired_major_version < $pe_major_version {
      # If requested major version is less than the current major version,
      # fail
      fail($errmsg)
    }
    elsif $desired_major_version == $::pe_major_version {
      # Check minor version to see if it's a potential downgrade.
      if $desired_minor_version < $::pe_minor_version {
        fail($errmsg)
      }
      elsif $desired_minor_version == $::pe_minor_version {
        # Major and minor versions match, finally check patch version to check
        # for downgrades.
        if $desired_patch_version < $::pe_patch_version {
          fail($errmsg)
        }
      }
    }
  }
  notify { "Upgrade from ${::pe_version} to ${version} passed all validation, beginning upgrade": }
  # Behold, staircase code!
}
