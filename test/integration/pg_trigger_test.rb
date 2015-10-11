require 'test_helper'

describe PGAssets::PGTrigger do
  describe ".ours" do
    it "lists the functions" do
      PGAssets::PGTrigger.ours.count.must_equal 0
      load_asset :trigger1
      PGAssets::PGTrigger.ours.count.must_equal 1
    end
  end
end
