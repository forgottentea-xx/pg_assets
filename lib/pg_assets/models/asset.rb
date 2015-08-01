class Asset < ActiveRecord::Base

  attr_accessor :cached_defn

  default_scope  {}

  def self.readonly?
    true
  end

  def remove
    ActiveRecord::Base.connection.execute sql_for_remove
  end

  def reinstall
    ActiveRecord::Base.connection.execute sql_for_reinstall
  end

  def identity
  end

  def sql_for_remove
  end

  def sql_for_reinstall
  end

  private

  def get_attribute_from_sql(sql, attribute)
    res = connection.execute sql
    res.first[attribute.to_s]
  end
end
