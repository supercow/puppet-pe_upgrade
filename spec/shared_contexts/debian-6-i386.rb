shared_context 'Debian 6 i386' do
  let(:facts) do
    {
      'operatingsystem'      => 'Debian',
      'hardwaremodel'        => 'i386',
      'pe_upgrade_extension' => 'tar.gz',
    }
  end
end
