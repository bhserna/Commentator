$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "commentator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "commentator"
  s.version     = Commentator::VERSION
  s.authors     = ["Benito Serna"]
  s.email       = ["bhserna@gmail.com"]
  s.homepage    = "http://bhserna.tumblr.com/"
  s.summary     = "Commentator is a javascript(well coffeescript) widget, to add comments to your Rails app in a simple way."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "jquery-rails", ">= 1.0.13"
  s.add_dependency "eco", "~> 1.0"
end
