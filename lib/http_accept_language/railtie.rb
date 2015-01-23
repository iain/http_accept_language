module HttpAcceptLanguage
  class Railtie < ::Rails::Railtie
    initializer "http_accept_language.setup" do |app|
      app.middleware.use Middleware

      ActiveSupport.on_load :action_controller do
        include EasyAccess

        if HttpAcceptLanguage.automatically_set_locale?
          require "http_accept_language/auto_locale"
          include AutoLocale
        end
      end
    end
  end

  module EasyAccess
    def http_accept_language
      @http_accept_language ||= request.env["http_accept_language.parser"] || Parser.new(request.env["HTTP_ACCEPT_LANGUAGE"])
    end
  end
end
