# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "minitest/autorun"
require 'pg_assets'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

def load_asset(asset_name)
  File.open(File.join('test', 'assets', asset_name.to_s + '.sql'), 'r') do |f|
    ActiveRecord::Base::connection.execute f.read
  end
end

MiniTest::TestUnit.add_teardown_hook { puts "foo" }

module ClearAssets
  include Minitest::Spec::DSL

  def after
    puts 'WAT'
    clear_assets
    super
  end

  private

  def clear_assets
    ActiveRecord::Base::connection.execute 'DROP VIEW IF EXISTS view1;'
  end
end
