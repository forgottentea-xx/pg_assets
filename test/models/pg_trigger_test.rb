require 'test_helper'

describe PgAssets::PGTrigger do
  describe ".ours" do
    it "lists the functions" do
      PgAssets::PGTrigger.ours.count.must_equal 0
      load_asset :trigger1
      PgAssets::PGTrigger.ours.count.must_equal 1
    end
  end

  describe "remove" do
    before do
      load_asset :trigger1
      load_asset :trigger2
      @trigger = PgAssets::PGTrigger.ours.first
    end
    it "removes the trigger" do
      PgAssets::PGTrigger.ours.count.must_equal 2
      @trigger.remove
      PgAssets::PGTrigger.ours.pluck(:tgname).include?(@trigger.tgname).must_equal false
    end
  end

  describe "reinstall" do
    before do
      load_asset :trigger1
      load_asset :trigger2
      @trigger = PgAssets::PGTrigger.ours.first
      @trigger.remove
    end
    it "reinstalls the function" do
      PgAssets::PGTrigger.ours.count.must_equal 1
      @trigger.reinstall
      PgAssets::PGTrigger.ours.pluck(:tgname).include?(@trigger.tgname).must_equal true
    end
  end
end
