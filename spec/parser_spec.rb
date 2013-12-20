require 'http_accept_language/parser'

describe HttpAcceptLanguage::Parser do

  def parser
    @parser ||= HttpAcceptLanguage::Parser.new('en-us,en-gb;q=0.8,en;q=0.6,es-419')
  end

  it "should return empty array" do
    parser.header = nil
    parser.user_preferred_languages.should eq []
  end

  it "should properly split" do
    parser.user_preferred_languages.should eq %w{en-US es-419 en-GB en}
  end

  it "should ignore jambled header" do
    parser.header = 'odkhjf89fioma098jq .,.,'
    parser.user_preferred_languages.should eq []
  end

  it "should properly respect whitespace" do
    parser.header = 'en-us, en-gb; q=0.8,en;q = 0.6,es-419'
    parser.user_preferred_languages.should eq %w{en-US es-419 en-GB en}
  end

  it "should find first available language" do
    parser.preferred_language_from(%w{en en-GB}).should eq "en-GB"
  end

  it "should find first compatible language" do
    parser.compatible_language_from(%w{en-hk}).should eq "en-hk"
    parser.compatible_language_from(%w{en}).should eq "en"
  end

  it "should find first compatible from user preferred" do
    parser.header = 'en-us,de-de'
    parser.compatible_language_from(%w{de en}).should eq 'en'
  end

  it "should accept symbols as available languages" do
    parser.header = 'en-us'
    parser.compatible_language_from([:"en-HK"]).should eq :"en-HK"
  end

  it "should sanitize available language names" do
    parser.sanitize_available_locales(%w{en_UK-x3 en-US-x1 ja_JP-x2 pt-BR-x5 es-419-x4}).should eq ["en-UK", "en-US", "ja-JP", "pt-BR", "es-419"]
  end

  it "should find most compatible language from user preferred" do
    parser.header = 'ja,en-gb,en-us,fr-fr'
    parser.language_region_compatible_from(%w{en-UK en-US ja-JP}).should eq "ja-JP"
  end

end
