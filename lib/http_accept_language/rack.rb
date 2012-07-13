module HttpAcceptLanguage
  class Rack

    def initialize(app)
      @app = app
    end

    def call(env)
      def env.http_accept_language
        @http_accept_language ||= Parser.new(self)
      end
      @app.call(env)
    end

  end
end
