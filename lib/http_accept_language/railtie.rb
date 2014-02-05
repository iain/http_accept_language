module HttpAcceptLanguage
  class Railtie < ::Rails::Railtie
    initializer "http_accept_language.add_middleware" do |app|
      app.middleware.use Middleware

      ActiveSupport.on_load :action_controller do
        include EasyAccess
        include AutoLocale if app.config.try(:i18n).try(:automatically_set_locale)
      end
    end
  end

  module EasyAccess
    def http_accept_language
      @http_accept_language ||= request.env["http_accept_language.parser"] || Parser.new("")
    end
  end

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
