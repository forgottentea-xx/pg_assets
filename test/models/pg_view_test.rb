require 'test_helper'

describe PgAssets::PgView do
  describe ".ours" do
    it "lists the views" do
      PgAssets::PgView.ours.count.must_equal 0
      load_asset :view1
      PgAssets::PgView.ours.count.must_equal 1
    end

    it "doesn't include materialized views" do
      load_asset :matview1
      load_asset :view1
      PgAssets::PgView.ours.count.must_equal 1
    end
  end

  describe "remove" do
    before do
      load_asset :view1
      load_asset :view2
      @view = PgAssets::PgView.ours.first
    end
    it "removes the view" do
      PgAssets::PgView.ours.count.must_equal 2
      @view.remove
      PgAssets::PgView.ours.pluck(:viewname).include?(@view.viewname).must_equal false
    end
  end

  describe "reinstall" do
    before do
      load_asset :view1
      load_asset :view2
      @view = PgAssets::PgView.ours.first
      @view.remove
    end
    it "reinstalls the view" do
      PgAssets::PgView.ours.count.must_equal 1
      @view.reinstall
      PgAssets::PgView.ours.pluck(:viewname).include?(@view.viewname).must_equal true
    end
  end
end
