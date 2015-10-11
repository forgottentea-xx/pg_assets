# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "minitest/autorun"
require 'pg_assets'
require 'database_cleaner'

# postgres has DDL in transactions, SWEET
DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# This is how we load assets fro test/assets/
def load_asset(asset_name)
  File.open(File.join('test', 'assets', asset_name.to_s + '.sql'), 'r') do |f|
    ActiveRecord::Base::connection.execute f.read
  end
end

class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end
