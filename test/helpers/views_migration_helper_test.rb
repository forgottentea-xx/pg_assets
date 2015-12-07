require 'test_helper'

describe PGAssets::ViewsMigrationHelper do
  include PGAssets::ViewsMigrationHelper
  before do
    load_asset :view1
    load_asset :matview1
  end

  describe '.touching_view with unchanged table' do
    it "removes and reinstalls the view" do
      PGAssets::PGView.ours.count.must_equal 1

      touching_view :view1 do
        PGAssets::PGView.ours.count.must_equal 0
      end

      PGAssets::PGView.ours.count.must_equal 1
    end

    # this is really a postgresql function.. not sure where else to test it though
    it "propogates table changes to the view" do
      load_asset :view_with_table
      asset_sql_before = PGAssets::Services::PGAssetManager.assets_dump

      ActiveRecord::Base.connection.execute <<-SQL
        ALTER TABLE table_for_view RENAME COLUMN test2 TO bomboclaat;
      SQL

      asset_sql_after = PGAssets::Services::PGAssetManager.assets_dump

      asset_sql_before.wont_match /bomboclaat/
      asset_sql_after.must_match /bomboclaat/
    end

    it "allows for changing a view" do
      asset_sql_before = PGAssets::Services::PGAssetManager.assets_dump

      new_view = <<-SQL
        CREATE OR REPLACE VIEW view1 AS
          SELECT 1, 2 AS "rasclaat";
      SQL

      touching_view :view1, new_view do
        wat = 'wat'
      end

      asset_sql_after = PGAssets::Services::PGAssetManager.assets_dump

      asset_sql_before.wont_match /rasclaat/
      asset_sql_after.must_match /rasclaat/
    end
  end

  describe '.touching_materialized_view with unchanged table' do
    it "removes and reinstalls the materialized view" do
      PGAssets::PGView.ours.count.must_equal 1

      touching_materialized_view :matview1 do
        PGAssets::PGMatView.ours.count.must_equal 0
      end

      PGAssets::PGMatView.ours.count.must_equal 1
    end

    # this is really a postgresql function.. not sure where else to test it though
    it "propogates table changes to the materilialized view" do
      load_asset :materialized_view_with_table
      asset_sql_before = PGAssets::Services::PGAssetManager.assets_dump

      ActiveRecord::Base.connection.execute <<-SQL
        ALTER TABLE table_for_view RENAME COLUMN test2 TO bomboclaat;
      SQL

      asset_sql_after = PGAssets::Services::PGAssetManager.assets_dump

      asset_sql_before.wont_match /bomboclaat/
      asset_sql_after.must_match /bomboclaat/
    end

    it "allows for changing a view" do
      asset_sql_before = PGAssets::Services::PGAssetManager.assets_dump

      new_view = <<-SQL
        CREATE MATERIALIZED VIEW matview1 AS
          SELECT 1, 2 AS "rasclaat";
      SQL

      touching_materialized_view :matview1, new_view do
        wat = 'wat'
      end

      asset_sql_after = PGAssets::Services::PGAssetManager.assets_dump

      asset_sql_before.wont_match /rasclaat/
      asset_sql_after.must_match /rasclaat/
    end
  end
end
