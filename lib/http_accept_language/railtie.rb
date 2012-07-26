module HttpAcceptLanguage
  class Railtie < ::Rails::Railtie

    initializer "http_accept_language.add_middleware" do |app|
      app.middleware.use Middleware
      
      ActiveSupport.on_load :action_controller do
        include EasyAccess
      end
    end

  end

  module EasyAccess
    def http_accept_language
      env.http_accept_language
    end
  end

end
