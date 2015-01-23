require 'active_support/concern'

module HttpAcceptLanguage
  module AutoLocale
    extend ActiveSupport::Concern

    included do
      before_filter :set_locale
    end

    private

    def set_locale
      I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
    end
  end
end
