module PGAssets
  class PGMatView < ActiveRecord::Base
    include LoadableAsset

    self.table_name = 'pg_catalog.pg_matviews'

    after_find do
      self.cached_defn = definition
    end

    scope :ours, -> { where.not(schemaname: ['pg_catalog', 'information_schema']) }

    def self.by_name(name)
      where(matviewname: name.to_s)
    end

    def identity
      schemaname + '.' + matviewname
    end

    def sql_for_remove
      sql = "DROP MATERIALIZED VIEW IF EXISTS #{schemaname}.#{matviewname}"
    end

    def sql_for_reinstall(defn=cached_defn)
      sql = "CREATE MATERIALIZED VIEW #{schemaname}.#{matviewname} AS #{defn}"
    end
  end
end
