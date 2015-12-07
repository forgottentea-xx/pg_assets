# This is to help you migrate things where there is a db dependency.
#
# Just include it in your migration, then pass your migration changes to it
# in a block, like this:
# in your migration like this
#
#
#     class BringThePain < ActiveRecord::Migration
#       include PGAssets::ViewsMigrationHelper
#
#       def change
#         touching_view :a_view do
#           change_column :sweet_table, :column_1, :text, :null => false
#         end
#       end
#     end
#
# You may also want to re-define the view if, for instance, you drop a column
#
#     class BringThePain < ActiveRecord::Migration
#       include PGAssets::ViewsMigrationHelper
#
#       def change
#         new_defn = 'SELECT id, column_1, column_3 FROM sweet_table'
#
#         touching_view :a_view, new_defn do
#           remove_column :sweet_table, :column_2
#         end
#       end
#     end
module PGAssets
  module ViewsMigrationHelper
    def touching_view(view_name, new_defn=nil, &proc)
      view = ::PGAssets::Services::PGAssetManager.specific_view(view_name.to_sym)
      view.remove

      proc.call

      if new_defn.nil?
        view.reinstall
      else
        view.reinstall(defn=new_defn)
      end
    end

    def touching_materialized_view(view_name, new_defn=nil, &proc)
      matview = ::PGAssets::Services::PGAssetManager.specific_matview(view_name.to_sym)
      matview.remove

      proc.call

      if new_defn.nil?
        matview.reinstall
      else
        matview.reinstall(defn=new_defn)
      end
    end
  end
end
