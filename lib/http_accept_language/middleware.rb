module HttpAcceptLanguage
  class Middleware
    # Pass `define_env_method: false` to skip defining `env.http_accept_language`.
    # Defining it creates a singleton class for every request's env Hash, and
    # Ruby's JIT compilers give up optimizations that assume Hash objects don't
    # have singleton classes once they do.
    # The parser is always available as `env["http_accept_language.parser"]`.
    def initialize(app, options = {})
      @app = app
      @define_env_method = options.fetch(:define_env_method, true)
    end

    def call(env)
      env["http_accept_language.parser"] = Parser.new(env["HTTP_ACCEPT_LANGUAGE"])

      if @define_env_method
        def env.http_accept_language
          self["http_accept_language.parser"]
        end
      end

      @app.call(env)
    end
  end
end
