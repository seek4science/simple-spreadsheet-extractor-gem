# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sysmodb/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple-spreadsheet-extractor'
  spec.version       = SysMODB::VERSION
  spec.authors       = ["Stuart Owen","Finn Bacall", "Quyen Nguyen"]
  spec.email         = ['stuart.owen@manchester.ac.uk']

  spec.summary       = 'Basic spreadsheet content extraction using Apache POI'
  spec.description   = 'Takes a stream to a spreadsheet file and produces an XML or CSV representation of its contents'
  spec.homepage      = 'http://github.com/myGrid/simple-spreadsheet-extractor-gem'
  spec.license       = 'BSD-3-Clause'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('libxml-ruby', '~> 2.9')
  spec.add_dependency('terrapin')

  spec.add_development_dependency('rubocop')
  spec.add_development_dependency('rubycritic')
  spec.add_development_dependency('bundler')

  spec.add_development_dependency('rake')
  spec.add_development_dependency('minitest')
end
