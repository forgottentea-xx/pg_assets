module PGAssets
  class PGFunction < ActiveRecord::Base
    include LoadableAsset

    self.table_name = 'pg_catalog.pg_proc'

    after_find do
      self.cached_defn = get_function_defn
    end

    scope :ours, -> {
      joins('JOIN pg_catalog.pg_namespace ON (pg_proc.pronamespace = pg_namespace.oid)').
      where('pg_namespace.nspname NOT IN (?)', ['pg_catalog', 'information_schema'])
    }

    def identity
      proname
    end

    # TODO get this to work with bomboclaat schemas
    def sql_for_remove
      sql = "DROP FUNCTION IF EXISTS #{proname}(#{get_function_args})"
    end

    def sql_for_reinstall
      cached_defn
    end

    private

    def get_oid
      sql = "SELECT oid FROM pg_catalog.pg_proc WHERE proname = '#{proname}' AND pronamespace = '#{pronamespace}'"
      get_attribute_from_sql sql, :oid
    end

    def get_function_defn
      sql = "SELECT pg_get_functiondef(#{get_oid}) AS functiondef"
      get_attribute_from_sql sql, :functiondef
    end

    def get_function_args
      sql = "SELECT pg_get_function_identity_arguments(#{get_oid}) AS functionargs"
      get_attribute_from_sql sql, :functionargs
    end
  end
end
