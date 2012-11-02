# == Class: pe_upgrade
#
# This class will perform the upgrade of PE to the specified version.
#
# == Parameters
#
# If a parameter is not specified, it will default to the value in
# pe_upgrade::data. See that class for values
#
# [*version*]
#
# [*answersfile*]
#
# [*download_dir*]
#
# [*timeout*]
#
# [*mode*]
#
# [*server*]
#
# [*certname*]
#
# [*allow_downgrade*]
#
# [*upgrade_master*]
#
# == Examples
#
#   # Install from Puppet Labs servers with all defaults
#   include pe_upgrade
#
#
#   # More customized
#   class { 'pe_upgrade':
#     version      => '2.5.0',
#     answersfile  => "site/answers/${fqdn}-answers.txt",
#     download_dir => 'https://local.site.downloads/puppet-enterprise/2.5.0',
#     timeout      => '3600',
#  }
#
# == Caveats
#
# This has only been tested for PE versions 2.0.0 and greater.
#
# == Authors
#
# Adrien Thebo <adrien@puppetlabs.com>
#
# == Copyright
#
# Copyright 2012 Puppet Labs Inc.
#
# == License
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class pe_upgrade(
  $download_dir   = $pe_upgrade::data::download_dir,
  $version        = $pe_upgrade::data::version,
  $answersfile    = $pe_upgrade::data::answersfile,
  $checksum       = $pe_upgrade::data::checksum,
  $timeout        = $pe_upgrade::data::timeout,
  $mode           = $pe_upgrade::data::mode,
  $server         = $pe_upgrade::data::server,
  $certname       = $pe_upgrade::data::certname,
  $force_upgrade  = $pe_upgrade::data::force_upgrade,
  $upgrade_master = $pe_upgrade::data::upgrade_master,
) inherits pe_upgrade::data {

  if $::pe_version == $version {
  }
  else {

    # ---------------
    # Munge variables

    $installer_dir = pe_pkgname($version)
    $installer_tar = "${installer_dir}.tar.gz"

    include "::staging"
    $staging_root = "${::staging::path}/pe_upgrade"

    anchor { 'pe_upgrade::begin': } ->
    class { 'pe_upgrade::validation': } ->
    class { 'pe_upgrade::staging':   timeout => $timeout } ->
    class { 'pe_upgrade::execution': timeout => $timeout } ->
    anchor { 'pe_upgrade::end': }
  }
}
