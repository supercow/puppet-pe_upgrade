require 'spec_helper'

describe 'pe_upgrade', :type => :class do
  let(:facts) do
    {
      'servername'           => 'a server and such',
      'clientcert'           => 'wat',
      'pe_upgrade_installer' => 'puppet-enterprise-2.3.1',
      'pe_upgrade_extension' => 'tar.gz',
      'pe_upgrade_version'   => '2.6.1',
    }
  end

  shared_examples_for 'orchestrating a Puppet Enterprise upgrade' do |platform|
    describe 'when PE is up to date' do
      let(:params) {{ 'version' => '2.5.3' }}

      describe 'and verbose is true' do
        it "adds a notify that the upgrade is complete"
      end

      describe 'and verbose is false' do
        it "doesn't add a notify"
      end

      it "purges the staging root of old installers"
    end

    describe 'when an upgrade is required' do
      describe 'with default params' do
        it do
          should contain_class('pe_upgrade::staging')
        end

        it do
          should contain_class('pe_upgrade::execution')
        end
      end
    end
  end

  on_all_platforms do |platform|
    it_behaves_like 'orchestrating a Puppet Enterprise upgrade', platform
  end
end
