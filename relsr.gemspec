# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'relsr/version'

Gem::Specification.new do |spec|
  spec.name                  = 'relsr'
  spec.version               = Relsr.version
  spec.authors               = ['John Cleary']
  spec.email                 = ['john@createk.io']
  spec.summary               = 'Command-line release managment tool for GitHub projects.'
  spec.homepage              = 'https://github.com/jcleary/relsr'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.0'

  spec.files = Dir['{lib,bin}/**/**']
  spec.executables << 'relsr'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15.3'
  spec.add_development_dependency 'rake', '~> 12.0.0'
  spec.add_development_dependency 'rspec', '~> 3.6.0'
  spec.add_development_dependency 'version', '~> 1.1.1'

  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_dependency 'netrc', '~> 0.11.0'
  spec.add_dependency 'octokit', '~> 4.7.0'
  spec.add_dependency 'rugged', '~> 0.26.0'
  spec.add_dependency 'thor', '~> 0.19.4'
end

