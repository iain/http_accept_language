require 'http_accept_language'

module HttpAcceptLanguage
  class Rack

    def initialize(app)
      @app = app
    end

    def call(env)
      def env.http_accept_language
        @http_accept_language ||= HttpAcceptLanguage.new(self)
      end
      @app.call(env)
    end

    class HttpAcceptLanguage
      include ::HttpAcceptLanguage

      attr_reader :env

      def initialize(env)
        @env = env
      end

    end

  end
end

