module Services
  class PGAssetReader

    def self.views
      PGView.ours.to_a.sort_by { |v| v.identity }
    end

    def self.specific_view(name)
      PGView.ours.by_name(name).first
    end

    def self.triggers
      PGTrigger.ours.to_a.sort_by { |t| t.identity }
    end

    def self.functions
      PGFunction.ours.to_a.sort_by { |f| f.identity }
    end

  #   class PGView < ActiveRecord::Base
  #     self.table_name = 'pg_catalog.pg_views'
  #
  #     attr_accessor :cached_defn
  #
  #     def self.readonly?
  #       true
  #     end
  #
  #     after_find do
  #       self.cached_defn = definition
  #     end
  #
  #     scope :ours, -> { where.not(schemaname: ['pg_catalog', 'information_schema']) }
  #
  #     def self.by_name(name)
  #       where(viewname: name.to_s)
  #     end
  #
  #     def identity
  #       schemaname + '.' + viewname
  #     end
  #
  #     def remove_sql
  #       sql = "
  #         DROP VIEW IF EXISTS #{schemaname}.#{viewname}
  #       "
  #     end
  #
  #     def remove
  #       connection.execute remove_sql
  #     end
  #
  #     def sql_for_reinstall(defn=cached_defn)
  #       sql = "CREATE OR REPLACE VIEW #{schemaname}.#{viewname} AS #{defn}"
  #     end
  #
  #     def reinstall(defn=cached_defn)
  #       connection.execute sql_for_reinstall(defn)
  #     end
  #   end
  #
  #   class PGTrigger < ActiveRecord::Base
  #     attr_accessor :cached_defn, :trigger_table_name
  #
  #     self.table_name = 'pg_catalog.pg_trigger'
  #
  #     after_find do
  #       self.cached_defn = get_trigger_defn
  #     end
  #
  #     def self.readonly?
  #       true
  #     end
  #
  #     scope :ours, -> { where(tgisinternal: false) }
  #
  #     def identity
  #       "#{tgname} ON #{get_trigger_table_name}"
  #     end
  #
  #     def sql_for_remove
  #       sql = "DROP TRIGGER IF EXISTS #{tgname} ON #{get_trigger_table_name}"
  #     end
  #
  #     def remove
  #       connection.execute sql_for_remove
  #     end
  #
  #     def sql_for_reinstall
  #       sql = cached_defn
  #     end
  #
  #     private
  #
  #     def get_trigger_table_name
  #       sql = "
  #         SELECT relname AS name FROM pg_class WHERE oid = #{tgrelid}
  #       "
  #       res = connection.execute sql
  #       res.first['name']
  #     end
  #
  #     def get_oid
  #       sql = "SELECT oid FROM pg_catalog.pg_trigger WHERE tgrelid = #{tgrelid} AND tgname = '#{tgname}'"
  #       res = connection.execute sql
  #       res.first['oid']
  #     end
  #
  #     def get_trigger_defn
  #       sql = "SELECT pg_get_triggerdef(#{get_oid}, true) AS triggerdef"
  #       res = connection.execute sql
  #       res.first['triggerdef']
  #     end
  #
  #   end
  #
  #   class PGFunction < ActiveRecord::Base
  #     self.table_name = 'pg_catalog.pg_proc'
  #
  #     attr_accessor :cached_defn
  #
  #     after_find do
  #       self.cached_defn = get_function_defn
  #     end
  #
  #     def self.readonly?
  #       true
  #     end
  #
  #     scope :ours, -> {
  #       joins('JOIN pg_catalog.pg_namespace ON (pg_proc.pronamespace = pg_namespace.oid)').
  #       where('pg_namespace.nspname NOT IN (?)', ['pg_catalog', 'information_schema'])
  #     }
  #
  #     def identity
  #       proname
  #     end
  #
  #     # TODO get this to work with bomboclaat schemas
  #     def sql_for_remove
  #       sql = "DROP FUNCTION IF EXISTS #{proname}(#{get_function_args})"
  #     end
  #
  #     def remove
  #       connection.execute sql_for_remove
  #     end
  #
  #     def sql_for_reinstall
  #       cached_defn
  #     end
  #
  #     def reinstall
  #       connection.execute sql_for_reinstall
  #     end
  #
  #     private
  #
  #     def get_oid
  #       sql = "SELECT oid FROM pg_catalog.pg_proc WHERE proname = '#{proname}' AND pronamespace = '#{pronamespace}'"
  #       res = connection.execute sql
  #       res.first['oid']
  #     end
  #
  #     def get_function_defn
  #       sql = "SELECT pg_get_functiondef(#{get_oid}) AS functiondef"
  #       res = connection.execute sql
  #       res.first['functiondef']
  #     end
  #
  #     def get_function_args
  #       sql = "SELECT pg_get_function_identity_arguments(#{get_oid}) AS functionargs"
  #       res = connection.execute sql
  #       res.first['functionargs']
  #     end
  #   end
  #
  #   # TODO fix all this
  #   class PGMatView < ActiveRecord::Base
  #     def self.readonly?
  #       true
  #     end
  #
  #     # W T F
  #     def self.all_names
  #       matviews = []
  #       result = connection.execute <<-SQL
  #         SELECT pg_class.oid::regclass::text, pg_namespace.nspname, oid
  #         FROM   pg_class
  #         JOIN   pg_catalog.pg_namespace
  #           ON   (pg_catalog.pg_namespace.oid = pg_catalog.pg_class.relnamespace)
  #         WHERE  relkind = 'm'
  #       SQL
  #
  #       result.each { |row| matviews << row['nspname'] + '.' + row['oid'] }
  #       matviews
  #     end
  #   end
   end
end
