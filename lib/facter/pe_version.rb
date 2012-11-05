# = Puppet enterprise version facts
#
# == Resolution:
#
# Parses the puppetversion fact and extracts the relevant substrings
#
# Some improvements blatantly stolen from https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/facter/pe_version.rb
#
# These facts may be deprecated in the future in favor of puppetlabs-stdlib

version_facts = {
  :pe_version       => lambda { |ver| ver },
  :pe_major_version => lambda { |ver| ver.split('.')[0] },
  :pe_minor_version => lambda { |ver| ver.split('.')[1] },
  :pe_patch_version => lambda { |ver| ver.split('.')[2] },
}

version_facts.each_pair do |fact_name, fact_resolution|
  Facter.add(fact_name) do
    setcode do
      if (ver_string = Facter.value(:puppetversion).scan(/\d+\.\d+\.\d+/)[1])
        fact_resolution.call(ver_string)
      end
    end
  end
end
