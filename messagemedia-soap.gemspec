# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'messagemedia/soap/version'

Gem::Specification.new do |spec|

  spec.name          = "messagemedia-soap"
  spec.version       = Messagemedia::SOAP::VERSION
  spec.authors       = ["Chris Hawkins", "Tristan Penman"]
  spec.email         = ["chris.hawkins@outlook.com", "tristan.penman@messagemedia.com.au"]
  spec.summary       = "Simple Ruby interface for the MessageMedia SOAP API"
  spec.description   = "Support for Ruby applications to integrate with the MessageMedia SOAP API"
  spec.homepage      = "http://www.messagemedia.com/"
  spec.license       = "Apache"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_dependency "savon", "~> 2.4"

end
