# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'relsr/version'

Gem::Specification.new do |spec|
  spec.name                  = 'relsr'
  spec.version               = Relsr::VERSION
  spec.authors               = ['John Cleary']
  spec.email                 = ['john@createk.io']
  spec.summary               = 'Command-line release managment tool for GitHub projects.'
  spec.homepage              = 'https://github.com/jcleary/relsr'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.0'

  spec.files = Dir['{lib,assets,bin}/**/**']
  spec.executables << 'relsr'
  spec.require_paths = ['lib']

  spec.add_dependency 'octokit', '~> 4.7'
  spec.add_dependency 'netrc', '~> 0.11'
end

