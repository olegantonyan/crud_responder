# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crud_responder/version'

Gem::Specification.new do |spec|
  spec.name          = "crud_responder"
  spec.version       = CrudResponder::VERSION
  spec.authors       = ["Oleg Antonyan"]
  spec.email         = ["oleg.b.antonyan@gmail.com"]

  spec.summary       = %q{DRY out your controler actions for CRUD operations with flash messages}
  spec.description   = %q{Don't repeat object.save, object.update, object.destroy and flash[:alert], flash[:notice] in every controller. Use action's name to decide what to do}
  spec.homepage      = "https://github.com/olegantonyan/crud_responder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_dependency "railties", ">= 4"
  spec.add_dependency "actionpack", ">= 4"
  spec.add_dependency "activesupport", ">= 4"
end
