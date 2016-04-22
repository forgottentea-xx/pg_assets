module PgAssets
  class PgTable < ActiveRecord::Base
    self.table_name = 'pg_catalog.pg_tables'
    scope :ours, -> { where.not(schemaname: ['pg_catalog', 'information_schema']) }

    def identity
      schemaname + '.' + tablename
    end
  end
end
