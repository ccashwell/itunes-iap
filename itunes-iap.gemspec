# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'itunes/iap/version'

Gem::Specification.new do |spec|
  spec.name          = "itunes-iap"
  spec.version       = Itunes::IAP::VERSION
  spec.authors       = ["Chris Cashwell"]
  spec.email         = ["ccashwell@gmail.com"]
  spec.summary       = "iTunes In-App Purchase and Subscription Receipt Analysis and Validation"
  spec.description   = "iTunes In-App Purchase and Subscription Receipt Analysis and Validation"
  spec.homepage      = "https://github.com/litehouselabs/itunes-iap"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
