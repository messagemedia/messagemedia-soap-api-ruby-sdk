# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require File.dirname(__FILE__) + '/lib/messagemedia/version'

Gem::Specification.new do |spec|
  spec.name          = 'messagemedia-ruby'
  spec.version       = Messagemedia::VERSION
  spec.authors       = ['Tristan Penman']
  spec.email         = ['tristan.penman@messagemedia.com.au']
  spec.summary       = 'Simple Ruby interface for the MessageMedia SOAP API'
  spec.description   = 'Support for Ruby applications to integrate with the MessageMedia SOAP API'
  spec.homepage      = 'http://www.messagemedia.com/'
  spec.license       = 'Apache'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_dependency 'rake'
  spec.add_dependency 'rspec'
  spec.add_dependency 'savon', '~> 2.4'
  spec.add_dependency 'test-unit'

end
