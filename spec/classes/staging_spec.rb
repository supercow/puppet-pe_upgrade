require 'spec_helper'

describe 'pe_upgrade::staging', :type => :class do
  let(:facts) {{
    'operatingsystem'      => 'CentOS',
    'architecture'         => 'i386',
    'pe_upgrade_extension' => 'tar.gz',
  }}

  let(:installer) { 'puppet-enterprise-2.5.3-el-6-i386' }

  let(:params) {{
    'installer'    => installer,
    'version'      => '2.5.3',
    'download_dir' => 'https://download.dir',
    'timeout'      => '300',
    'staging_root' => '/opt/staging/pe_upgrade',
  }}


  it do
    should contain_staging__file("#{installer}.tar.gz").with({
      'source'  => "https://download.dir/2.5.3/#{installer}.tar.gz",
      'timeout' => '300',
    })
  end

  it do
    should contain_staging__extract("#{installer}.tar.gz").with({
      'target' => '/opt/staging/pe_upgrade',
    })
  end
end
