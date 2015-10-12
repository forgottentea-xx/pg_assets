require 'test_helper'

describe PGAssets::PGView do
  describe ".ours" do
    it "lists the views" do
      PGAssets::PGView.ours.count.must_equal 0
      load_asset :view1
      PGAssets::PGView.ours.count.must_equal 1
    end
  end

  describe "remove" do
    before do
      load_asset :view1
      load_asset :view2
      @view = PGAssets::PGView.ours.first
    end
    it "removes the view" do
      PGAssets::PGView.ours.count.must_equal 2
      @view.remove
      PGAssets::PGView.ours.pluck(:viewname).include?(@view.viewname).must_equal false
    end
  end

  describe "reinstall" do
    before do
      load_asset :view1
      load_asset :view2
      @view = PGAssets::PGView.ours.first
      @view.remove
    end
    it "reinstalls the view" do
      PGAssets::PGView.ours.count.must_equal 1
      @view.reinstall
      PGAssets::PGView.ours.pluck(:viewname).include?(@view.viewname).must_equal true
    end
  end
end
