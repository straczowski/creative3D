# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'creative3D/version'

Gem::Specification.new do |spec|
  spec.name          = "creative3D"
  spec.version       = Creative3D::VERSION
  spec.authors       = ["Raoul"]
  spec.email         = ["raoulstraczowski@googlemail.com"]
  spec.description   = "A library for rapid prototyping and 3D Modelling"
  spec.summary       = "Summary kommt auch noch"
  spec.homepage      = "https://github.com/straczowski/creative3D"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "gmath3D"
end

# git add .
# gem build creative3D.gemspec
# gem install creative3D-0.0.1.gem