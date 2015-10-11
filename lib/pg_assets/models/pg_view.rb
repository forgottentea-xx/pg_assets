module PGAssets
  class PGView < ActiveRecord::Base
    include LoadableAsset

    self.table_name = 'pg_catalog.pg_views'

    after_find do
      self.cached_defn = definition
    end

    scope :ours, -> { where.not(schemaname: ['pg_catalog', 'information_schema']) }

    def self.by_name(name)
      where(viewname: name.to_s)
    end

    def identity
      schemaname + '.' + viewname
    end

    def sql_for_remove
      sql = "DROP VIEW IF EXISTS #{schemaname}.#{viewname}"
    end

    def sql_for_reinstall(defn=cached_defn)
      sql = "CREATE OR REPLACE VIEW #{schemaname}.#{viewname} AS #{defn}"
    end
  end
end
