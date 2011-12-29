require 'spec_helper'

describe Destination do
  context "validates :hashtag" do
    before  { subject.hashtag = hashtag }

    context "when nil" do
      let(:hashtag) { nil }
      it { should have_errors_on(:hashtag).with_message("can't be blank") }
    end

    context "when blank" do
      let(:hashtag) { "" }
      it { should have_errors_on(:hashtag).with_message("can't be blank") }
    end

    context "when preceded by a '#'" do
      let(:hashtag) { "#myhashtag" }

      it { should be_valid }

      it "strips the hashtag" do
        subject.valid?
        subject.hashtag.should eql("myhashtag")
      end
    end
  end
end