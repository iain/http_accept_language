require 'forwardable'

module HttpAcceptLanguage
  module Rails

    extend Forwardable

    def http_accept_language
      @http_accept_language_parser ||= Parser.new(env['HTTP_ACCEPT_LANGUAGE'])
    end

    def_delegators :http_accept_language_parser,
      :user_preferred_languages, :user_preferred_languages=,
      :preferred_language_from, :compatible_language_from,
      :sanitize_available_locales, :language_region_compatible_from

  end

end

classes = if ActionPack::VERSION::MAJOR == 2
            [ActionController::Request, ActionController::CgiRequest]
          else
            [ActionDispatch::Request]
          end

classes.each { |c| c.send :include, HttpAcceptLanguage::Rails }
