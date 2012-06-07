$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "haml_sprockets_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "haml_sprockets_engine"
  s.version     = HamlSprocketsEngine::VERSION
  s.authors     = ["Arwid Bancewicz"]
  s.email       = ["arwid@arwid.ca"]
  s.homepage    = "http://arwid.ca"
  s.summary     = "Haml Sprockets engine"
  s.description = "Haml Sprockets engine"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"

  s.add_development_dependency "sqlite3"
end
