module PGAssets
  module Services
    class PGAssetManager

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

      def self.assets_dump
        newline = "\n"
        assets = ''

        assets << '------------------------------ PG ASSETS ------------------------------' + newline
        assets << '--  BRO, DON\'T MODIFY THIS DIRECTLY' + newline
        assets << '--  IF YOU MODIFY THIS DIRECTLY,' + newline
        assets << '--  YOU\'RE GONNA HAVE A BAD TIME' + newline
        assets << '-----------------------------------------------------------------------' + newline

        views.each do |v|
          assets << newline
          assets << newline
          assets << '-----------------------------------------------------------------------' + newline
          assets << '---------- VIEW: ' + v.identity + newline
          assets << '-----------------------------------------------------------------------' + newline
          assets << v.sql_for_reinstall
        end

        functions.each do |f|
          assets << newline
          assets << newline
          assets << '-----------------------------------------------------------------------' + newline
          assets << '---------- FUNCTION: ' + f.identity + newline
          assets << '-----------------------------------------------------------------------' + newline
          assets << f.sql_for_reinstall + ';' + newline
        end

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
