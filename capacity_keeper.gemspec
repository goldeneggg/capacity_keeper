# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capacity_keeper/version'

Gem::Specification.new do |spec|
  spec.name          = "capacity_keeper"
  spec.version       = CapacityKeeper::VERSION
  spec.authors       = ["goldeneggg"]
  spec.email         = ["jpshadowapps@gmail.com"]

  spec.summary       = %q{simple and pluggable capacity keeping tool for your processes}
  spec.description   = %q{simple and pluggable capacity keeping tool for your processes}
  spec.homepage      = "https://github.com/goldeneggg/capacity_keeper"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.0.0"
  spec.add_development_dependency "rspec", "~> 3.6.0"
  spec.add_development_dependency 'pry', '~> 0.10.4'
  spec.add_development_dependency 'pry-byebug', '~> 3.5.0'
  spec.add_development_dependency 'pry-doc', '~> 0.11.1'
  spec.add_development_dependency 'pry-theme', '~> 1.2.0'
end
