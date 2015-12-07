require 'pg'

require File.expand_path('../pg_assets/models/concerns/loadable_asset', __FILE__)
require File.expand_path('../pg_assets/models/pg_constraint', __FILE__)
require File.expand_path('../pg_assets/models/pg_trigger', __FILE__)
require File.expand_path('../pg_assets/models/pg_mat_view', __FILE__)
require File.expand_path('../pg_assets/models/pg_view', __FILE__)
require File.expand_path('../pg_assets/models/pg_function', __FILE__)
require File.expand_path('../pg_assets/services/pg_asset_manager', __FILE__)
require File.expand_path('../pg_assets/helpers/views_migration_helper', __FILE__)
require File.expand_path('../pg_assets/version', __FILE__)

module PgAssets
  require 'pg_assets/railtie' if defined?(Rails)
end
