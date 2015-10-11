require 'test_helper'

describe PGFunction do
  describe ".ours" do
    it "lists the functions" do
      PGFunction.ours.count.must_equal 0
      load_asset :function1
      PGFunction.ours.count.must_equal 1
    end
  end
end
