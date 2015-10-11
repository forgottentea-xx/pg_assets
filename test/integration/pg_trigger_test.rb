require 'test_helper'

describe PGTrigger do
  describe ".function" do
    it "lists the functions" do
      PGTrigger.ours.count.must_equal 0
      load_asset :trigger1
      PGTrigger.ours.count.must_equal 1
    end
  end
end
