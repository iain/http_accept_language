require 'rails'
require 'http_accept_language/parser'
require 'http_accept_language/railtie'

describe HttpAcceptLanguage::Railtie do

  describe HttpAcceptLanguage::AutoLocale do
    let(:controller_class) {
      Class.new do
        def self.before_filter(dummy) ; end
        def http_accept_language ; HttpAcceptLanguage::Parser.new("ja,en-us;q=0.7,en;q=0.3") ; end
        include HttpAcceptLanguage::AutoLocale
      end
    }
    let(:controller) { controller_class.new }

    context "available languages includes accept_languages" do
      before { I18n.available_locales = [:en, :ja] }
      it "take a suitable locale" do
        expect{ controller.set_locale }.to change{ I18n.locale }.to(:ja)
      end
    end

    context "available languages not includes accept_languages" do
      before do
        I18n.available_locales = [:de]
        I18n.default_locale = :fr
      end
      it "take default_locale" do
        expect{ controller.set_locale }.to change{ I18n.locale }.to(:fr)
      end
    end
  end
end
