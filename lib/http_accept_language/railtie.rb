module HttpAcceptLanguage
  class Railtie < ::Rails::Railtie
    config.http_accept_language = ActiveSupport::OrderedOptions.new
    config.http_accept_language.define_env_method = true

    initializer "http_accept_language.add_middleware" do |app|
      app.middleware.use Middleware, define_env_method: app.config.http_accept_language.define_env_method

      ActiveSupport.on_load :action_controller do
        include EasyAccess
      end
    end
  end

  module EasyAccess
    def http_accept_language
      @http_accept_language ||= request.env["http_accept_language.parser"] || Parser.new(request.env["HTTP_ACCEPT_LANGUAGE"])
    end
  end
end
