require 'spec_helper'

describe Group do

  context "validates :phone_number" do
    before { subject.phone_number = phone_number }

    context "when nil" do
      let(:phone_number) { nil }
      it { should have_errors_on(:phone_number).with_message("can't be blank") }
    end

    context "when blank" do
      let(:phone_number) { "" }
      it { should have_errors_on(:phone_number).with_message("can't be blank") }
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

  before(:all) do
    $outbound_flocky = '' unless $outbound_flocky
  end
  before(:each) do
    @group = FactoryGirl.create(:group)
  end

  describe "send_message" do
    before :each do
      @email_student=FactoryGirl.create(:student,:email=>"abc@def.com", :phone_number=>nil)
      @group.students << @email_student
      $outbound_flocky=""
      $outbound_flocky.should_receive(:message)
    end
    it "should send emails to users without phone numbers" do
      $outbound_flocky.stub(:message)
      mailer = mock(:mail)
      mailer.should_receive(:deliver)
      NotificationMailer.should_receive(:notification_email).with(/test message/,@email_student,@group).and_return(mailer)
      @group.send_message("test message",@group.user)
    end
    it "if fails sending email with an exception, should not fail" do
      mailer = mock(:mail)
      mailer.should_receive(:deliver).and_raise("stubbed problem with delivery")
      NotificationMailer.should_receive(:notification_email).with(/test message/,@email_student,@group).and_return(mailer)
      @group.send_message("test message",@group.user)
    end
  end

  describe "replies_all" do
    before :each do
      @student = FactoryGirl.create(:student)
      @group.students << @student
      $outbound_flocky=""
    end

    it "when updated, should inform students" do
      $outbound_flocky.should_receive(:message).with(@group.phone_number,/settings.*changed.*everyone/,[@student.phone_number])
      @group.update_attribute(:replies_all, true)

      $outbound_flocky.should_receive(:message).with(@group.phone_number,/settings.*changed.*only/,[@student.phone_number])
      @group.update_attribute(:replies_all, false)
    end

    it "when not updated when group is saved, should not notify students" do
      @group.update_attribute(:title,"new group name")
    end

  end

end
