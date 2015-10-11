module PGAssets
  module LoadableAsset
    extend ActiveSupport::Concern

    included do
      def self.readonly?
        true
      end

      def remove
        ActiveRecord::Base.connection.execute sql_for_remove
      end

      def reinstall
        ActiveRecord::Base.connection.execute sql_for_reinstall
      end

      private

      def get_attribute_from_sql(sql, attribute)
        res = ActiveRecord::Base.connection.execute sql
        res.first[attribute.to_s]
      end
    end
  end
end
