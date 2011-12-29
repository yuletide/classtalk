require 'spec_helper'

describe Student do

  context "validates :phone_number" do
    let(:email) { nil }

    before do
      subject.phone_number = phone_number
      subject.email        = email
    end

    context "when :email is blank" do
      context "when :phone_number is nil" do
        let(:phone_number) { nil }
        it { should have_errors_on(:base).with_message("either phone_number or email must be present") }
      end

      context "when :phone_number is blank" do
        let(:phone_number) { "" }
        it { should have_errors_on(:base).with_message("either phone_number or email must be present") }
      end
    end

    context "when :email is present" do
      let(:email) { "abc@def.com" }

      context "when :phone_number is nil" do
        let(:phone_number) { nil }
        it { should_not have_errors_on(:phone_number) }
      end

      context "when :phone_number is blank" do
        let(:phone_number) { "" }
        it { should_not have_errors_on(:phone_number) }
      end
    end

    context "when non-numeric" do
      let(:phone_number) { "abc123" }
      it { should have_errors_on(:phone_number).with_message("phone number must be 10 digits, and of the form 'xxxxxxxxxx'") }
    end

    context "when formatted" do
      let(:phone_number) { "(123) 456-7890" }
      it { should_not have_errors_on(:phone_number) }
    end

    context "when unformatted" do
      let(:phone_number) { "0123456789" }
      it { should_not have_errors_on(:phone_number) }
    end
  end

  context "validates :name" do
    before  { subject.name = name }

    context "when nil" do
      let(:name) { nil }
      it { should have_errors_on(:name).with_message("can't be blank") }
    end

    context "when blank" do
      let(:name) { "" }
      it { should have_errors_on(:name).with_message("can't be blank") }
    end
  end

  describe "their group memberships" do
    pending "students can be members of no groups" do
    end
    pending "students can be members of exactly one group" do
    end
    pending "students can be members of multiple groups" do
    end
    pending "students can't be in the same group twice at the same time" do
    end
  end
end
