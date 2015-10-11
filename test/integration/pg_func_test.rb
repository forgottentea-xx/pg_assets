require 'test_helper'

describe PGAssets::PGFunction do
  describe ".ours" do
    it "lists the functions" do
      PGAssets::PGFunction.ours.count.must_equal 0
      load_asset :function1
      PGAssets::PGFunction.ours.count.must_equal 1
    end
  end
end
