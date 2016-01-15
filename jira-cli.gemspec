# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jira/constants"

Gem::Specification.new do |s|
  s.name        = 'jira-cli2'
  s.version     = Jira::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Darren Lin Cheng', 'Shayan Darayan']
  s.email       = ['darren@thanx.com', 'sdarayan.public@gmail.com']
  s.homepage    = 'https://github.com/sdarayan/jira-cli'
  s.summary     = 'JIRA CLI'
  s.description = 'CLI used to manage JIRA workflows leveraging git'
  s.license     = 'MIT'

  s.files       = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.executables = ['jira']
  s.require_paths = ['lib']

  s.add_dependency 'thor', '~> 0.19.1', '>= 0.19.1'
  s.add_dependency 'faraday', '~> 0.9.0', '>= 0.9.0'
  s.add_dependency 'inquirer', '~> 0.2.1', '>= 0.2.1'
  s.add_dependency 'inifile', '~> 2.0.2', '>= 2.0.2'
end
