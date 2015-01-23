module HttpAcceptLanguage
  @@automatically_set_locale = false

  def self.automatically_set_locale?
    @@automatically_set_locale
  end

  def self.automatically_set_locale=(set_locale)
    @@automatically_set_locale = set_locale
  end
end

require 'http_accept_language/parser'
require 'http_accept_language/middleware'
require 'http_accept_language/railtie' if defined?(Rails::Railtie)