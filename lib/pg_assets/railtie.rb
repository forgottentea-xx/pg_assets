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
  end
end
