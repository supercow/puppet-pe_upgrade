shared_context 'CentOS 5 i386' do
  let(:facts) do
    {
      'operatingsystem'      => 'CentOS',
      'hardwaremodel'        => 'i386',
      'pe_upgrade_extension' => 'tar.gz',
    }
  end
end
