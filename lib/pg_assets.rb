require 'pg'
require 'active_support/all'
require 'active_record'

require_relative 'pg_assets/models/concerns/loadable_asset'
require_relative 'pg_assets/models/pg_constraint'
require_relative 'pg_assets/models/pg_trigger'
require_relative 'pg_assets/models/pg_mat_view'
require_relative 'pg_assets/models/pg_view'
require_relative 'pg_assets/models/pg_function'
require_relative 'pg_assets/models/pg_table'
require_relative 'pg_assets/services/pg_asset_manager'
require_relative 'pg_assets/helpers/views_migration_helper'
require_relative 'pg_assets/dependency'
require_relative 'pg_assets/version'

module PgAssets
  require 'pg_assets/railtie' if defined?(Rails)

  Config = Struct.new :manage_constraints,
                      :manage_functions,
                      :manage_matviews,
                      :manage_triggers,
                      :manage_views

  def self.config
    @config ||= Config.new true, true, true, true, true
  end
end
