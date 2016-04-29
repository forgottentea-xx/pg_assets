module PgAssets
  module Services
    class PgAssetManager

      def self.views
        PgAssets.config.manage_views or return []
        PgView.ours.to_a.sort_by { |v| v.identity }
      end

      def self.matviews
        PgAssets.config.manage_matviews or return []
        PgMatView.ours.to_a.sort_by { |v| v.identity }
      end

      def self.triggers
        PgAssets.config.manage_triggers or return []
        PgTrigger.ours.to_a.sort_by { |t| t.identity }
      end

      def self.functions
        PgAssets.config.manage_functions or return []
        PgFunction.ours.to_a.sort_by { |f| f.identity }
      end

      def self.constraints
        PgAssets.config.manage_constraints or return []
        PgConstraint.ours.to_a.sort_by { |f| f.identity }
      end

      def self.assets_by_identity
        assets = views +
          matviews +
          functions +
          triggers +
          constraints
        assets.inject({}) {|memo, a| memo[a.identity] = a; memo }
      end

      def self.assets_dump
        newline = "\n"
        output = ''

        output << '------------------------------ PG ASSETS ------------------------------' + newline
        output << '--  BRO, DON\'T MODIFY THIS DIRECTLY' + newline
        output << '--  IF YOU MODIFY THIS DIRECTLY,' + newline
        output << '--  YOU\'RE GONNA HAVE A BAD TIME' + newline
        output << '-----------------------------------------------------------------------' + newline

        assets = assets_by_identity
        Dependency.new.tsort.each do |identity|
          asset = assets.delete identity
          asset or next

          output << newline
          output << newline
          output << '-----------------------------------------------------------------------' + newline
          output << "---------- #{asset.class.to_s.demodulize.upcase.sub('PG', '')}: " + asset.identity + newline
          output << '-----------------------------------------------------------------------' + newline
          output << asset.sql_for_reinstall
        end

        # any left overs
        assets.values.each do |asset|
          output << newline
          output << newline
          output << '-----------------------------------------------------------------------' + newline
          output << "---------- #{asset.class.to_s.demodulize.upcase.sub('PG', '')}: " + asset.identity + newline
          output << '-----------------------------------------------------------------------' + newline
          output << asset.sql_for_reinstall
        end

        output
      end

      def self.assets_load(assets)
        ActiveRecord::Base.transaction do
          ActiveRecord::Base.connection.execute assets
        end
      end
    end
  end
end
