$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pg_assets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pg_assets"
  s.version     = PgAssets::VERSION
  s.authors     = ["Jeff Osborn"]
  s.email       = ["jeff.osborn@cohealo.com"]
  s.summary     = "Managing your database assets right right way."
  s.description = "Mostly seamless management of functions, triggers, views, and materialized views, similar to schema.rb/structure.sql"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.12"

  s.add_dependency "pg"
  s.add_development_dependency "minitest"
  s.add_development_dependency "database_cleaner"
end
