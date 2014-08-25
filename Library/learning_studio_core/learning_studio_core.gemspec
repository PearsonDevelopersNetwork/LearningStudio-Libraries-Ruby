# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'learning_studio_core/version'

Gem::Specification.new do |gem|
  gem.name           = "learning_studio_core"
  gem.version        = LearningStudioCore::VERSION
  gem.authors        = ["Vasanth Balakrishnan"]
  gem.email          = ["vasantheb@gmail.com"]
  gem.summary        = %q{Pearson - Learning Studio core library in Ruby}
  gem.description    = gem.summary
  gem.homepage        = ""

  gem.add_dependency 'httpclient'
  gem.add_dependency 'nokogiri'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths  = ["lib"]
  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", '~> 2.14.1'
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "factory_girl", "~> 4.0"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "minitest-reporters", "~> 1.0", ">= 1.0.5"
end
