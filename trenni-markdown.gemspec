# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trenni/markdown/version'

Gem::Specification.new do |spec|
  spec.name          = "trenni-markdown"
  spec.version       = Trenni::Markdown::VERSION
  spec.authors       = ["Samuel Williams"]
  spec.email         = ["samuel.williams@oriontransfer.co.nz"]

  spec.summary       = %q{A simple event-generating Markdown parser.}
  spec.homepage      = "https://github.com/ioquatix/trenni-markdown"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "trenni", "~> 1.6.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
