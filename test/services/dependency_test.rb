require 'test_helper'

describe PgAssets::Services::PgAssetManager do
  before do
    load_asset :dependent_views
  end

  describe ".assets_dump" do
    it "creates an asset dump" do
      regexes = [
        /dependentview1/,
        /dependentview2/,
        /dependentview3/,
      ]
      assets_dump = PgAssets::Services::PgAssetManager.assets_dump
      regexes.each do |regex|
        assets_dump.must_match regex
      end
    end
  end

  describe ".assets_load" do
    before do
      @assets = PgAssets::Services::PgAssetManager.assets_dump
      PgAssets::PgView.by_name('dependentview1').first.remove
      PgAssets::PgView.by_name('dependentview3').first.remove
      PgAssets::PgView.by_name('dependentview2').first.remove
    end

    it "loads the assets" do
      PgAssets::Services::PgAssetManager.views.size.must_equal 0
      PgAssets::Services::PgAssetManager.assets_load @assets
      PgAssets::Services::PgAssetManager.views.size.must_equal 3
    end

    it "does not load assets twice if the rake task is run twice" do
      PgAssets::Services::PgAssetManager.views.size.must_equal 0
      PgAssets::Services::PgAssetManager.assets_load @assets
      PgAssets::Services::PgAssetManager.views.size.must_equal 3
      PgAssets::Services::PgAssetManager.assets_load @assets
      PgAssets::Services::PgAssetManager.views.size.must_equal 3
      PgAssets::Services::PgAssetManager.assets_dump.must_equal @assets
    end
  end
end
