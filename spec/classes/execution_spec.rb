require 'spec_helper'

describe 'pe_upgrade::execution', :type => :class do

  shared_examples_for "running a Puppet Enterprise upgrade" do
    let(:params) do
      {
        'certname'      => 'node-to-upgrade',
        'installer_dir' => '/opt/staging/pe_upgrade/puppet-enterprise-2.5.3',
        'logfile'       => false,
        'mode'          => 'upgrade',
        'migrate_certs' => false,
        'server'        => 'server-node',
        'staging_root'  => '/opt/staging/pe_upgrade',
        'timeout'       => '300',
        'answersfile'   => 'pe_upgrade/answers/default-agent.txt.erb',
      }
    end

    it do
      should contain_file('/opt/staging/pe_upgrade/answers.txt').with({
        'ensure'  => 'present',
        'content' => /.+/,
        'owner'   => '0',
        'group'   => '0',
      })
    end

    it do
      should contain_exec('Validate answers').with({
        'command'   => /puppet-enterprise-upgrader.*-n/,
        'user'      => '0',
        'group'     => '0',
        'logoutput' => 'on_failure',
        'timeout'   => '300',
      })
    end

    it do
      should contain_exec('Run upgrade').with({
        'command'   => /puppet-enterprise-upgrader/,
        'user'      => '0',
        'group'     => '0',
        'logoutput' => 'on_failure',
        'timeout'   => '300',
      })
    end
  end

  on_all_platforms do |platform|
    it_behaves_like "running a Puppet Enterprise upgrade"
  end
end
