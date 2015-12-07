require 'test_helper'

describe PGAssets::PGConstraint do
  describe ".ours" do
    it "lists the constraints" do
      PGAssets::PGConstraint.ours.count.must_equal 0
      load_asset :constraint_check
      PGAssets::PGConstraint.ours.count.must_equal 1
    end
  end

  describe "remove" do
    it "removes the constraint" do
      load_asset :constraint_unique
      load_asset :constraint_check
      @constraint = PGAssets::PGConstraint.ours.first
      PGAssets::PGConstraint.ours.count.must_equal 2
      @constraint.remove
      PGAssets::PGConstraint.ours.pluck(:conname).include?(@constraint.conname).must_equal false
    end

    it "doesn't effect other constraints" do
      load_asset :constraint_multiple
      PGAssets::PGConstraint.ours.count.must_equal 3

      @constraint = PGAssets::PGConstraint.ours.sample
      @constraint.remove
      PGAssets::PGConstraint.ours.count.must_equal 2

      @constraint = PGAssets::PGConstraint.ours.sample
      @constraint.remove
      PGAssets::PGConstraint.ours.count.must_equal 1

      @constraint = PGAssets::PGConstraint.ours.sample
      @constraint.remove
      PGAssets::PGConstraint.ours.count.must_equal 0
    end
  end

  describe "reinstall" do
    before do
      load_asset :constraint_unique
      load_asset :constraint_check
      @constraint = PGAssets::PGConstraint.ours.first
      @constraint.remove
    end
    it "reinstalls the constraint" do
      PGAssets::PGConstraint.ours.count.must_equal 1
      @constraint.reinstall
      PGAssets::PGConstraint.ours.pluck(:conname).include?(@constraint.conname).must_equal true
    end
  end
end
