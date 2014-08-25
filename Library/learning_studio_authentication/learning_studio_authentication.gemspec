# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "learning_studio_authentication/version"

Gem::Specification.new do |gem|
  gem.name          = "learning_studio_authentication"
  gem.version       = LearningStudioAuthentication::VERSION
  gem.authors       = ["Vasanth Balakrishnan"]
  gem.email         = ["vasantheb@gmail.com"]
  gem.summary       = %q{Pearson - Learning Studio authentication wrapper in Ruby}
  gem.description   = %q{Ruby wrapper around Pearson's Authentication APIs for Learning Studio.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "ext"]
  gem.extensions = Dir["ext/**/extconf.rb"]

  gem.add_dependency "httpclient", "~> 2.4", ">= 2.4.0"

  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake", "~> 10.3", ">=10.3.1"
  gem.add_development_dependency "rspec", "~> 2.14", ">= 2.14.1"
  gem.add_development_dependency "minitest", "~> 5.3", ">= 5.3.4"
  gem.add_development_dependency "factory_girl", "~> 4.0", ">= 4.0.0"
  gem.add_development_dependency "simplecov", "~> 0.8", ">= 0.8.0"
  gem.add_development_dependency "minitest-reporters", "~> 1.0", ">= 1.0.5"
end
