# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "http_accept_language"
  s.version     = '1.0.2'
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
end
