# Fact: pe_upgrade_installer
#
# Purpose: provide the PE installer package name
#
# Resolution: Provide the worst implementation of fizz buzz ever


Facter.add(:pe_upgrade_installer) do

  setcode do
    case Facter.value(:osfamily)
    when 'Debian'
      pkg_name = Facter.value(:operatingsystem).downcase
    when 'RedHat'
      pkg_name = 'el'
    when 'Suse'
      pkg_name = 'sles'
    when 'Solaris', 'AIX'
      pkg_name = Facter.value(:osfamily)
    end

    arch    = Facter.value(:architecture)
    release = Facter.value(:operatingsystemrelease)

    "puppet-enterprise-:version-#{pkg_name}-#{release}-#{arch}.tar.gz"
  end
end

Facter.add(:pe_upgrade_installer) do
  confine :kernel => 'windows'
  setcode { 'puppet-enterprise-:version' }
end
