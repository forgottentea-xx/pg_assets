require 'test_helper'

describe PgAssets::PgConstraint do
  describe ".ours" do
    it "lists the constraints" do
      PgAssets::PgConstraint.ours.count.must_equal 0
      load_asset :constraint_check
      PgAssets::PgConstraint.ours.count.must_equal 1
    end
  end

  describe "remove" do
    it "removes the constraint" do
      load_asset :constraint_unique
      load_asset :constraint_check
      @constraint = PgAssets::PgConstraint.ours.first
      PgAssets::PgConstraint.ours.count.must_equal 2
      @constraint.remove
      PgAssets::PgConstraint.ours.pluck(:conname).include?(@constraint.conname).must_equal false
    end

    it "doesn't effect other constraints" do
      load_asset :constraint_multiple
      PgAssets::PgConstraint.ours.count.must_equal 3

      @constraint = PgAssets::PgConstraint.ours.sample
      @constraint.remove
      PgAssets::PgConstraint.ours.count.must_equal 2

      @constraint = PgAssets::PgConstraint.ours.sample
      @constraint.remove
      PgAssets::PgConstraint.ours.count.must_equal 1

      @constraint = PgAssets::PgConstraint.ours.sample
      @constraint.remove
      PgAssets::PgConstraint.ours.count.must_equal 0
    end
  end

  describe "reinstall" do
    before do
      load_asset :constraint_unique
      load_asset :constraint_check
      @constraint = PgAssets::PgConstraint.ours.first
      @constraint.remove
    end
    it "reinstalls the constraint" do
      PgAssets::PgConstraint.ours.count.must_equal 1
      @constraint.reinstall
      PgAssets::PgConstraint.ours.pluck(:conname).include?(@constraint.conname).must_equal true
    end
  end
end
