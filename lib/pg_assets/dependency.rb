module PgAssets

  # Dependencies resolver between objects using tsort. Works with
  # "#{schema}.#{name}" strings instead of active record objects.
  class Dependency
    include TSort

    def self.dependencies(name)
      # just throw away the schema for now
      name = name.split('.').last

      query = <<-SQL
        SELECT cl_d.relname AS name, n.nspname as schema
        FROM pg_rewrite AS r
        JOIN pg_class AS cl_r ON r.ev_class=cl_r.oid
        JOIN pg_depend AS d ON r.oid=d.objid
        JOIN pg_class AS cl_d ON d.refobjid=cl_d.oid
        JOIN pg_namespace as n ON cl_d.relnamespace = n.oid
        WHERE cl_d.relkind IN ('r','v')
        AND cl_r.relname='#{name}'
        AND cl_d.relname != '#{name}'
        GROUP BY cl_d.relname, n.nspname
        ORDER BY cl_d.relname
      SQL

      PgView.connection.select_all(query).map do |r|
        "#{r['schema']}.#{r['name']}"
      end
    end

    def tsort_each_child(node, &block)
      self.class.dependencies(node).each(&block)
    end

    def tsort_each_node(&block)
      (PgView.ours + PgTable.ours).map(&:identity).each(&block)
    end
  end
end

