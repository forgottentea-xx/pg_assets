module PGAssets
  class PGTrigger < ActiveRecord::Base
    include LoadableAsset

    attr_accessor :trigger_table_name

    self.table_name = 'pg_catalog.pg_trigger'

    after_find do
      self.cached_defn = get_trigger_defn
    end

    # this is wrong.  this should join on pg_class to get the table, and then
    # pg_schema to get the schema, and then exclude those other schemas
    scope :ours, -> { where(tgisinternal: false) }

    def identity
      "#{tgname} ON #{get_trigger_table_name}"
    end

    def sql_for_remove
      sql = "DROP TRIGGER IF EXISTS #{tgname} ON #{get_trigger_table_name}"
    end

    def sql_for_reinstall
      sql = cached_defn
    end

    private

    def get_trigger_table_name
      sql = "SELECT relname AS name FROM pg_class WHERE oid = #{tgrelid}"
      get_attribute_from_sql sql, :name
    end

    def get_oid
      sql = "SELECT oid FROM pg_catalog.pg_trigger WHERE tgrelid = #{tgrelid} AND tgname = '#{tgname}'"
      get_attribute_from_sql sql, :oid
    end

    def get_trigger_defn
      sql = "SELECT pg_get_triggerdef(#{get_oid}, true) AS triggerdef"
      get_attribute_from_sql sql, :triggerdef
    end
  end
end
