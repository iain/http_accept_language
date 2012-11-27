module HttpAcceptLanguage
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      env["http_accept_language"] = Parser.new(env['HTTP_ACCEPT_LANGUAGE'])
      def env.http_accept_language
        self["http_accept_language"]
      end
      @app.call(env)
    end

  end
end
