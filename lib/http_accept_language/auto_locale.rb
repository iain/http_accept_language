require 'active_support/concern'

module HttpAcceptLanguage
  module AutoLocale
    extend ActiveSupport::Concern

    included do
      if respond_to?(:around_action)
        around_action :use_locale
      else
        arund_filter :use_locale
      end
    end

    private

    def use_locale(&blk)
      locale = http_accept_language.compatible_language_from(I18n.available_locales)
      I18n.with_locale(locale, &blk)
    end
  end
end
