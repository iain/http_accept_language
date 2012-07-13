module HttpAcceptLanguage
  class Railtie < ::Rails::Railtie

    initializer "http_accept_language.add_middleware" do |app|
      app.middleware.use Middleware
    end

  end
end
