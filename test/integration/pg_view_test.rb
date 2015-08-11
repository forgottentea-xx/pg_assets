require 'test_helper'
include ClearAssets

describe PGView do
  describe ".views" do
    it "lists the views" do
      PGView.ours.count.must_equal 0
      load_asset :view1
      PGView.ours.count.must_equal 1
    end
  end
end
