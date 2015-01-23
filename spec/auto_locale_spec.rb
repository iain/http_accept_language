require 'http_accept_language/auto_locale'

describe HttpAcceptLanguage::AutoLocale do
  let(:controller_class) do
    Class.new do
      def self.before_filter(dummy) 

      end

      def http_accept_language
        HttpAcceptLanguage::Parser.new("ja,en-us;q=0.7,en;q=0.3")
      end

      include HttpAcceptLanguage::AutoLocale
    end
  end

  let(:controller) { controller_class.new }

  context "available languages includes accept_languages" do
    before do
      I18n.available_locales = [:en, :ja]
    end

    it "take a suitable locale" do
      controller.set_locale

      expect(I18n.locale).to eq(:ja)
    end
  end

  context "available languages not includes accept_languages" do
    before do
      I18n.available_locales = [:de]
      I18n.default_locale = :fr
    end

    it "take default_locale" do
      controller.set_locale

      expect(I18n.locale).to eq(:fr)
    end
  end
end