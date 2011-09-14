require 'spec_helper'

describe Destination do
  before(:each) do
    @destination = FactoryGirl.create(:destination)
  end

  describe "hashtag" do
    it "must be present" do
      @destination.hashtag = nil
      @destination.should_not be_valid
      @destination.errors.keys.should be_include(:hashtag)
    end

    it "must not start with a #, and must strip leading '#' if given" do
      #I don't know how to skip before_validation, to make sure it's actually invalid if it somehow gets through.
      @destination.hashtag = "#myhashtag"
      @destination.should be_valid
      @destination.hashtag.should_not =~ /^#/
    end

  end

end