# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-file"
  spec.version       = "0.0.1"
  spec.authors       = ["Elias Hasnat"]
  spec.email         = ["h...e...@gmail.com"]
  spec.summary       = %q{fluentd file parser plugin}
  spec.description   = %q{fluentd file parser plugin}
  spec.homepage      = "http://github.com/claymodel/fluent-plugin-file"
  spec.license       = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fluentd"

end
