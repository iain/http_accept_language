require "active_support/concern"
require "i18n"

module HttpAcceptLanguage
  module AutoLocale
    extend ActiveSupport::Concern

    included do
      before_filter :set_locale
    end

    def set_locale
      I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
    end
  end
end