class PGMatView < ActiveRecord::Base
  def self.readonly?
    true
  end

  # W T F
  def self.all_names
    matviews = []
    result = connection.execute <<-SQL
      SELECT pg_class.oid::regclass::text, pg_namespace.nspname, oid
      FROM   pg_class
      JOIN   pg_catalog.pg_namespace
        ON   (pg_catalog.pg_namespace.oid = pg_catalog.pg_class.relnamespace)
      WHERE  relkind = 'm'
    SQL

    result.each { |row| matviews << row['nspname'] + '.' + row['oid'] }
    matviews
  end
end
