require 'pg'

require_relative 'pg_assets/models/concerns/loadable_asset'
require_relative 'pg_assets/models/pg_constraint'
require_relative 'pg_assets/models/pg_trigger'
require_relative 'pg_assets/models/pg_mat_view'
require_relative 'pg_assets/models/pg_view'
require_relative 'pg_assets/models/pg_function'
require_relative 'pg_assets/services/pg_asset_manager'
require_relative 'pg_assets/helpers/views_migration_helper'
require_relative 'pg_assets/version'

module PgAssets
  require 'pg_assets/railtie' if defined?(Rails)
end
