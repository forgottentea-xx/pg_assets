require 'test_helper'

describe PGAssets::PGView do
  describe ".ours" do
    it "lists the views" do
      PGAssets::PGView.ours.count.must_equal 0
      load_asset :view1
      PGAssets::PGView.ours.count.must_equal 1
    end
  end
end
