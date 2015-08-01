class PGTrigger < ActiveRecord::Base
  attr_accessor :cached_defn, :trigger_table_name

  self.table_name = 'pg_catalog.pg_trigger'

  after_find do
    self.cached_defn = get_trigger_defn
  end

  def self.readonly?
    true
  end

  scope :ours, -> { where(tgisinternal: false) }

  def identity
    "#{tgname} ON #{get_trigger_table_name}"
  end

  def sql_for_remove
    sql = "DROP TRIGGER IF EXISTS #{tgname} ON #{get_trigger_table_name}"
  end

  def remove
    connection.execute sql_for_remove
  end

  def sql_for_reinstall
    sql = cached_defn
  end

  private

  def get_trigger_table_name
    sql = "
      SELECT relname AS name FROM pg_class WHERE oid = #{tgrelid}
    "
    res = connection.execute sql
    res.first['name']
  end

  def get_oid
    sql = "SELECT oid FROM pg_catalog.pg_trigger WHERE tgrelid = #{tgrelid} AND tgname = '#{tgname}'"
    res = connection.execute sql
    res.first['oid']
  end

  def get_trigger_defn
    sql = "SELECT pg_get_triggerdef(#{get_oid}, true) AS triggerdef"
    res = connection.execute sql
    res.first['triggerdef']
  end

end
