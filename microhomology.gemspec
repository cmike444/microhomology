# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microhomology/version'

Gem::Specification.new do |spec|
  spec.name          = "Microhomology"
  spec.version       = Microhomology::VERSION
  spec.authors       = ["Chris Mikelson"]
  spec.email         = ["chrismikelson@gmail.com"]
  spec.summary       = %q{Perform simultaneous microhomology strategies with ease using CRISPR or TALEN techniques.}
  spec.description   = %q{Simultaneously perform custom microhomoly strategies for genetic engineering and bioinformatics.}
  spec.homepage      = "https://github.com/cmike444/microhomology"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", '~> 0'
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "coveralls"

  spec.add_runtime_dependency "json", '~> 1.8', '>= 1.8.3'
  spec.add_runtime_dependency "bio", '~> 1.5', '>= 1.5.0'
end
