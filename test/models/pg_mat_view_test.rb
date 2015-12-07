require 'test_helper'

describe PGAssets::PGMatView do
  describe ".ours" do
    it "lists the materialized views" do
      PGAssets::PGMatView.ours.count.must_equal 0
      load_asset :matview1
      PGAssets::PGMatView.ours.count.must_equal 1
    end

    it "doesn't include regular views" do
      load_asset :matview1
      load_asset :view1
      PGAssets::PGMatView.ours.count.must_equal 1
    end
  end

  describe "remove" do
    before do
      load_asset :matview1
      load_asset :matview2
      @matview = PGAssets::PGMatView.ours.first
    end
    it "removes the materialized view" do
      PGAssets::PGMatView.ours.count.must_equal 2
      @matview.remove
      PGAssets::PGMatView.ours.pluck(:matviewname).include?(@matview.matviewname).must_equal false
    end
  end

  describe "reinstall" do
    before do
      load_asset :matview1
      load_asset :matview2
      @matview = PGAssets::PGMatView.ours.first
      @matview.remove
    end
    it "reinstalls the materialized view" do
      PGAssets::PGMatView.ours.count.must_equal 1
      @matview.reinstall
      PGAssets::PGMatView.ours.pluck(:matviewname).include?(@matview.matviewname).must_equal true
    end
  end
end
