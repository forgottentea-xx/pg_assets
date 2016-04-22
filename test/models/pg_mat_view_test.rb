require 'test_helper'

describe PgAssets::PgMatView do
  describe ".ours" do
    it "lists the materialized views" do
      PgAssets::PgMatView.ours.count.must_equal 0
      load_asset :matview1
      PgAssets::PgMatView.ours.count.must_equal 1
    end

    it "doesn't include regular views" do
      load_asset :matview1
      load_asset :view1
      PgAssets::PgMatView.ours.count.must_equal 1
    end
  end

  describe "remove" do
    before do
      load_asset :matview1
      load_asset :matview2
      @matview = PgAssets::PgMatView.ours.first
    end
    it "removes the materialized view" do
      PgAssets::PgMatView.ours.count.must_equal 2
      @matview.remove
      PgAssets::PgMatView.ours.pluck(:matviewname).include?(@matview.matviewname).must_equal false
    end
  end

  describe "reinstall" do
    before do
      load_asset :matview1
      load_asset :matview2
      @matview = PgAssets::PgMatView.ours.first
      @matview.remove
    end
    it "reinstalls the materialized view" do
      PgAssets::PgMatView.ours.count.must_equal 1
      @matview.reinstall
      PgAssets::PgMatView.ours.pluck(:matviewname).include?(@matview.matviewname).must_equal true
    end
  end
end
