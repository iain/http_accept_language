# -*- encoding: utf-8 -*-
require File.expand_path('../lib/http_accept_language/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "http_accept_language"
  s.version     = HttpAcceptLanguage::VERSION
  s.authors     = ["iain"]
  s.email       = ["iain@iain.nl"]
  s.homepage    = "https://github.com/iain/http_accept_language"
  s.summary     = %q{Find out which locale the user preferes by reading the languages they specified in their browser}
  s.description = %q{Find out which locale the user preferes by reading the languages they specified in their browser}

  s.rubyforge_project = "http_accept_language"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '<= 3.2.13'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rails', '>= 3.2.6'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'
end
