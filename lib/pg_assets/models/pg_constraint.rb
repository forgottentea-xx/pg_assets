module PGAssets
  class PGConstraint < ActiveRecord::Base
    include LoadableAsset

    self.table_name = 'pg_catalog.pg_constraint'

    after_find do
      self.cached_defn = get_constraint_defn
    end

    scope :ours, -> {
      joins('JOIN pg_catalog.pg_namespace ON (pg_constraint.connamespace = pg_namespace.oid)').
      where('pg_namespace.nspname NOT IN (?)', ['pg_catalog', 'information_schema']).
      where('conrelid != 0')  #exclude non-table constraints.  Not sure what to do with domain constraints yet
    }

    def identity
      "#{conname} on #{get_table_name}"
    end

    def sql_for_remove
      sql = "ALTER TABLE #{get_table_name} DROP CONSTRAINT IF EXISTS #{conname}"
    end

    def sql_for_reinstall
      sql = "#{sql_for_remove}; ALTER TABLE #{get_table_name} ADD CONSTRAINT #{conname} #{cached_defn}"
    end

    private

    def get_oid
      sql = "SELECT oid FROM pg_catalog.pg_constraint WHERE conname = '#{conname}' AND connamespace = '#{connamespace}'"
      get_attribute_from_sql sql, :oid
    end

    def get_table_name
      sql = "SELECT relname FROM pg_catalog.pg_class WHERE oid = #{conrelid}"
      get_attribute_from_sql sql, :relname
    end

    def get_constraint_defn
      sql = "SELECT pg_get_constraintdef(#{get_oid}, true) AS constraintdef"
      get_attribute_from_sql sql, :constraintdef
    end
  end
end
