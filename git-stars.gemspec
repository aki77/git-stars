# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git-stars/version'

Gem::Specification.new do |spec|
  spec.name          = 'git-stars'
  spec.version       = GitStars::VERSION
  spec.authors       = ['rochefort']
  spec.email         = ['terasawan@gmail.com']

  spec.summary       = 'CLI-Based tool that show your starred projects'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/rochefort/git-stars'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|img)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'actionview', '~> 4.2'
  spec.add_dependency 'api_cache',  '~> 0.3'
  spec.add_dependency 'colorize',   '~> 0.7'
  spec.add_dependency 'moneta',     '~> 0.8'
  spec.add_dependency 'netrc',      '~> 0.7'
  spec.add_dependency 'octokit',    '~> 4.1'
  spec.add_dependency 'thor',       '~> 0.19'
  spec.add_dependency 'terminal-table-unicode', '~> 0.1'
  spec.add_dependency 'unicode-display_width', '~> 0.1.1'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake',    '~> 10.0'
end
