# = Puppet enterprise version facts
#
# == Resolution:
#
# Parses the puppetversion fact and extracts the relevant substrings
#

version_facts = {
  :pe_version       => lambda { |ver| ver },
  :pe_major_version => lambda { |ver| ver.split('.')[0] },
  :pe_minor_version => lambda { |ver| ver.split('.')[1] },
  :pe_patch_version => lambda { |ver| ver.split('.')[2] },
}

version_facts.each_pair do |fact_name, fact_resolution|
  Facter.add(fact_name) do
    setcode do
      ver_string = Facter.value(:puppetversion).scan(/\d+\.\d+\.\d+/).last
      fact_resolution.call(ver_string)
    end
  end
end
