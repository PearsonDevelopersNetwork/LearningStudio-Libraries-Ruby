# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'learning_studio_exams/version'

Gem::Specification.new do |gem|
  gem.name          = "learning_studio_exams"
  gem.version       = LearningStudioExams::VERSION
  gem.authors       = ["Vasanth Balakrishnan"]
  gem.email         = ["vasantheb@gmail.com"]
  gem.summary       = %q{Learning Studio Exams}
  gem.description   = gem.summary
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", '~> 2.14.1'
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "factory_girl", "~> 4.0"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "minitest-reporters", "~> 1.0", ">= 1.0.5"
end
