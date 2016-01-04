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
      load 'tasks/pg_assets.rake'
    end

    # some of the column types in the pg_catalog views are not registered.
    # We don't really need them, but we'll register them so we don't get ugly
    # error messages
    initializer 'pg_assets.register_types' do
      case Rails::VERSION::STRING.to_f
      when 4.0..4.1
        UNREGISTERED_TYPES.each_pair do |pgtype, aliastype|
          unless ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID.registered_type?(pgtype)
            ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID.alias_type(pgtype.to_s, aliastype)
          end
        end
      when 4.2
        # from https://ericboehs.com/2015/09/17/adding-a-custom-postgres-type-in-rails-4-2/
        ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
          def initialize_type_map_with_postgres_oids mapping
            initialize_type_map_without_postgres_oids mapping
            UNREGISTERED_TYPES.each_pair do |pgtype, aliastype|
              register_class_with_limit mapping, pgtype.to_s, ActiveRecord::Type::String
            end

            # this one is special, since its an array and AR 4.2 changed the way this works
            register_class_with_limit mapping, 'aclitem[]', ActiveRecord::Type::String
          end
          alias_method_chain :initialize_type_map, :postgres_oids
        end
      end
    end
  end
end
