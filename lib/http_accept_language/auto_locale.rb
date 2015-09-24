require 'active_support/concern'

module HttpAcceptLanguage
  module AutoLocale
    extend ActiveSupport::Concern

    included do
      before_filter :set_locale
    end

    private

    def set_locale
      hal = http_accept_language
      hal.header ||= I18n.default_locale.to_s
      I18n.locale = hal.compatible_language_from(I18n.available_locales)
    end
  end
end
