module PlatformHelpers
  def platforms
    [
      'CentOS 5 i386',
      'Debian 6 i386',
    ]
  end

  def on_all_platforms(&block)
    raise unless block

    platforms.each do |platform|
      describe "on #{platform}" do
        include_context platform
        yield block, platform
      end
    end
  end

end

RSpec.configure do |config|
  config.extend PlatformHelpers
end
