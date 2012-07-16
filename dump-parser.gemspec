# -*- encoding: utf-8 -*-

require File.expand_path('../lib/dump_parser/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'dump_parser'
  gem.version     = DumpParser::VERSION.dup
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@seonic.net' ]
  gem.description = 'Unpowerful but easy DSL to parse (CSV) inputs'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/mbj/dump_parser'

  gem.require_paths    = [ 'lib' ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md TODO]

  gem.add_dependency('backports')

  gem.add_development_dependency('rspec',     '~> 1.3.2')
end
