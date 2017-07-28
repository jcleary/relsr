# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'releaser/version'

Gem::Specification.new do |spec|
  spec.name                  = 'releaser'
  spec.version               = releaser::VERSION
  spec.authors               = ['John Cleary']
  spec.email                 = ['john@createk.io']
  spec.summary               = 'Command-line release managment tool for GitHub projects.'
  spec.homepage              = 'https://github.com/jcleary/releaser'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.0'

  spec.files = Dir['{lib,assets,bin}/**/**']
  spec.executables << 'releaser'
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'octokit', '~> 4.7'
  spec.add_dependency 'netrc', '~> 0.11'
  spec.add_dependency 'colorize'
end

