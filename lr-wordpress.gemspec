# coding: utf-8
require File.expand_path('../lib/lr_wordpress/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = "lr-wordpress"
  s.version       = WP::VERSION
  s.authors       = ["Nick Reed"]
  s.email         = ["reednj77@gmail.com"]

  s.summary       = "Wordpress API Rails integration for LAN Resources apps"
  s.homepage      = "https://github.com/LANResources/lr-wordpress"
  s.license       = "MIT"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'httparty'
  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake", "~> 10.0"
end
