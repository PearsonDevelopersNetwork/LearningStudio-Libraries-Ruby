# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'learning_studio_grades/version'

Gem::Specification.new do |spec|
  spec.name          = "learning_studio_grades"
  spec.version       = LearningStudioGrades::VERSION
  spec.authors       = ["Vasanth Balakrishnan"]
  spec.email         = ["vasantheb@gmail.com"]
  spec.summary       = %q{Learning Studio Grades}
  spec.description   = %q{Ruby wrappers around Learning Studio Grades API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '~> 2.14.1'
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "factory_girl", "~> 4.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "minitest-reporters", "~> 1.0", ">= 1.0.5"
end
