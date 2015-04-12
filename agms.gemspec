# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'agms/version'

Gem::Specification.new do |spec|
  spec.name          = "agms"
  spec.version       = Agms::VERSION
  spec.authors       = ["Maanas Royy"]
  spec.email         = ["maanas@agms.com"]

  spec.summary       = %q{AGMS Ruby Client Library}
  spec.description   = %q{Ruby Library for integrating AGMS Gateway}
  spec.homepage      = "http://www.onlinepaymentprocessing.com"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  end

  spec.add_development_dependency 'nokogiri', '~> 1.5.10'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'mocha'
end
