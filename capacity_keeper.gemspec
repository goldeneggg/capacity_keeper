
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capacity_keeper/version'

Gem::Specification.new do |spec|
  spec.name          = "capacity_keeper"
  spec.version       = CapacityKeeper::VERSION
  spec.authors       = ["goldeneggg"]
  spec.email         = ["jpshadowapps@gmail.com"]

  spec.summary       = %q{Simple and pluggable capacity keeping tool for your processes}
  spec.description   = %q{Simple and pluggable capacity keeping tool for your processes}
  spec.homepage      = "https://github.com/goldeneggg/capacity_keeper"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/goldeneggg/capacity_keeper"
    spec.metadata["changelog_uri"] = "https://github.com/goldeneggg/capacity_keeper/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.3.0"
  spec.add_development_dependency "rspec", "~> 3.8.0"
  spec.add_development_dependency 'pry', '~> 0.12.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.6.0'
  spec.add_development_dependency 'pry-doc', '~> 1.0.0'
  spec.add_development_dependency 'pry-theme', '~> 1.2.0'
  spec.add_development_dependency 'github_changelog_generator', '~> 1.14.0'
end
