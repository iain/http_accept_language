require 'http_accept_language'

class MockedCgiRequest
  include HttpAcceptLanguage
  def env
    @env ||= {'HTTP_ACCEPT_LANGUAGE' => 'en-us,en-gb;q=0.8,en;q=0.6,es-419'}
  end
end

describe HttpAcceptLanguage do

  it "should return empty array" do
    request.env['HTTP_ACCEPT_LANGUAGE'] = nil
    request.user_preferred_languages.should eq []
  end

  it "should properly split" do
    request.user_preferred_languages.should eq %w{en-US es-419 en-GB en}
  end

  it "should ignore jambled header" do
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'odkhjf89fioma098jq .,.,'
    request.user_preferred_languages.should eq []
  end

  it "should find first available language" do
    request.preferred_language_from(%w{en en-GB}).should eq "en-GB"
  end

  it "should find first compatible language" do
    request.compatible_language_from(%w{en-hk}).should eq "en-hk"
    request.compatible_language_from(%w{en}).should eq "en"
  end

  it "should find first compatible from user preferred" do
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,de-de'
    request.compatible_language_from(%w{de en}).should eq 'en'
  end

  it "should accept symbols as available languages" do
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us'
    request.compatible_language_from([:"en-HK"]).should eq :"en-HK"
  end

  it "should sanitize available language names" do
    request.sanitize_available_locales(%w{en_UK-x3 en-US-x1 ja_JP-x2 pt-BR-x5}).should eq ["en-UK", "en-US", "ja-JP", "pt-BR"]
  end

  it "should find most compatible language from user preferred" do
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'ja,en-gb,en-us,fr-fr'
    request.language_region_compatible_from(%w{en-UK en-US ja-JP}).should eq "ja-JP"
  end

  def request
    @request ||= MockedCgiRequest.new
  end

end
