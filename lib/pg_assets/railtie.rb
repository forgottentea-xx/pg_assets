require 'pg_assets'
require 'rails'

module PgAssets
  class Railtie < Rails::Railtie
    railtie_name :pg_assets

    UNREGISTERED_TYPES = {
      regproc: 'text',
      pg_node_tree: 'text',
      aclitem: 'text'
    }

    rake_tasks do
      load '../../tasks/pg_assets.rake'
    end

    # some of the column types in the pg_catalog views are not registered.
    # We don't really need them, but we'll register them so we don't get ugly
    # error messages
    initializer 'pg_assets.register_types' do
      UNREGISTERED_TYPES.each_pair do |pgtype, aliastype|
        unless ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID.registered_type?(pgtype)
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID.alias_type(pgtype.to_s, aliastype)
        end
      end
    end
  end
end
