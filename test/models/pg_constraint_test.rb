require 'test_helper'

describe PgAssets::PGConstraint do
  describe ".ours" do
    it "lists the constraints" do
      PgAssets::PGConstraint.ours.count.must_equal 0
      load_asset :constraint_check
      PgAssets::PGConstraint.ours.count.must_equal 1
    end
  end

  describe "remove" do
    it "removes the constraint" do
      load_asset :constraint_unique
      load_asset :constraint_check
      @constraint = PgAssets::PGConstraint.ours.first
      PgAssets::PGConstraint.ours.count.must_equal 2
      @constraint.remove
      PgAssets::PGConstraint.ours.pluck(:conname).include?(@constraint.conname).must_equal false
    end

    it "doesn't effect other constraints" do
      load_asset :constraint_multiple
      PgAssets::PGConstraint.ours.count.must_equal 3

      @constraint = PgAssets::PGConstraint.ours.sample
      @constraint.remove
      PgAssets::PGConstraint.ours.count.must_equal 2

      @constraint = PgAssets::PGConstraint.ours.sample
      @constraint.remove
      PgAssets::PGConstraint.ours.count.must_equal 1

      @constraint = PgAssets::PGConstraint.ours.sample
      @constraint.remove
      PgAssets::PGConstraint.ours.count.must_equal 0
    end
  end

  describe "reinstall" do
    before do
      load_asset :constraint_unique
      load_asset :constraint_check
      @constraint = PgAssets::PGConstraint.ours.first
      @constraint.remove
    end
    it "reinstalls the constraint" do
      PgAssets::PGConstraint.ours.count.must_equal 1
      @constraint.reinstall
      PgAssets::PGConstraint.ours.pluck(:conname).include?(@constraint.conname).must_equal true
    end
  end
end
