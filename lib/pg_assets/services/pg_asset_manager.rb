module PgAssets
  module Services
    class PGAssetManager

      def self.views
        PGView.ours.to_a.sort_by { |v| v.identity }
      end

      def self.specific_view(name)
        PGView.ours.by_name(name).first
      end

      def self.matviews
        PGMatView.ours.to_a.sort_by { |v| v.identity }
      end

      def self.specific_matview(name)
        PGMatView.ours.by_name(name).first
      end

      def self.triggers
        PGTrigger.ours.to_a.sort_by { |t| t.identity }
      end

      def self.functions
        PGFunction.ours.to_a.sort_by { |f| f.identity }
      end

      def self.constraints
        PGConstraint.ours.to_a.sort_by { |f| f.identity }
      end

      def self.assets_dump
        newline = "\n"
        assets = ''

        assets << '------------------------------ PG ASSETS ------------------------------' + newline
        assets << '--  BRO, DON\'T MODIFY THIS DIRECTLY' + newline
        assets << '--  IF YOU MODIFY THIS DIRECTLY,' + newline
        assets << '--  YOU\'RE GONNA HAVE A BAD TIME' + newline
        assets << '-----------------------------------------------------------------------' + newline

        if PgAssets.config.manage_views
          views.each do |v|
            assets << newline
            assets << newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << '---------- VIEW: ' + v.identity + newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << v.sql_for_reinstall
          end
        end

        if PgAssets.config.manage_matviews
          matviews.each do |mv|
            assets << newline
            assets << newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << '---------- MATERIALIZED VIEW: ' + mv.identity + newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << mv.sql_for_reinstall
          end
        end

        if PgAssets.config.manage_functions
          functions.each do |f|
            assets << newline
            assets << newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << '---------- FUNCTION: ' + f.identity + newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << f.sql_for_reinstall + ';' + newline
          end
        end

        if PgAssets.config.manage_triggers
          triggers.each do |t|
            assets << newline
            assets << newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << '---------- TRIGGER: ' + t.identity + newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << t.sql_for_remove + ';' + newline
            assets << newline
            assets << t.sql_for_reinstall + ';' + newline
          end
        end

        if PgAssets.config.manage_constraints
          constraints.each do |c|
            assets << newline
            assets << newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << '---------- CONSTRAINT: ' + c.identity + newline
            assets << '-----------------------------------------------------------------------' + newline
            assets << c.sql_for_reinstall + ';' + newline
          end
        end

        assets
      end

      def self.assets_load(assets)
        ActiveRecord::Base.transaction do
          ActiveRecord::Base.connection.execute assets
        end
      end
    end
  end
end
