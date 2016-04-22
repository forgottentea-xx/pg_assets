require 'test_helper'

describe PgAssets::PgFunction do
  describe ".ours" do
    it "lists the functions" do
      PgAssets::PgFunction.ours.count.must_equal 0
      load_asset :function1
      PgAssets::PgFunction.ours.count.must_equal 1
    end
  end

  describe "remove" do
    before do
      load_asset :function2
      load_asset :function1
      @function = PgAssets::PgFunction.ours.first
    end
    it "removes the function" do
      PgAssets::PgFunction.ours.count.must_equal 2
      @function.remove
      PgAssets::PgFunction.ours.pluck(:proname).include?(@function.proname).must_equal false
    end
  end

  describe "reinstall" do
    before do
      load_asset :function1
      load_asset :function2
      @function = PgAssets::PgFunction.ours.first
      @function.remove
    end
    it "reinstalls the function" do
      PgAssets::PgFunction.ours.count.must_equal 1
      @function.reinstall
      PgAssets::PgFunction.ours.pluck(:proname).include?(@function.proname).must_equal true
    end
  end
end
