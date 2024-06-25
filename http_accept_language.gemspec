require_relative "lib/http_accept_language/version"

Gem::Specification.new do |spec|
  spec.authors = ["iain"]
  spec.email = ["iain@iain.nl"]
  spec.homepage = "https://github.com/iain/http_accept_language"
  spec.license = "MIT"
  spec.name = "http_accept_language"
  spec.required_ruby_version = ">= 3.0.0"
  spec.summary = "Find out which locale the user prefers by reading the languages they specified in their browser."
  spec.version = HttpAcceptLanguage::VERSION

  spec.files = Dir[
    "lib/**/*",
    "README.md",
    "LICENSE.txt",
  ]

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
