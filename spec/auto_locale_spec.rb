require 'i18n'
require 'http_accept_language/auto_locale'
require 'http_accept_language/parser'
require 'http_accept_language/middleware'

describe HttpAcceptLanguage::AutoLocale do
  let(:controller_class) do
    Class.new do
      def self.around_action(dummy)
        # dummy method
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
      expect(I18n.locale).to eq(:en)
      controller.send(:use_locale) do
        expect(I18n.locale).to eq(:ja)
      end
      expect(I18n.locale).to eq(:en)
    end
  end
end
