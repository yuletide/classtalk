require 'spec_helper'

describe Group do
  before(:each) do
    @group = FactoryGirl.create(:group)
  end

  describe "their phone number" do
    it "may NOT be blank" do
      @group.phone_number=nil
      @group.should_not be_valid
      @group.phone_number=""
      @group.should_not be_valid
    end
    it "if present, must be valid" do
      @group.phone_number="abc123"
      @group.should_not be_valid
      @group.phone_number="(123) 456-7890"
      @group.should be_valid
      @group.phone_number="1234567891"
      @group.should be_valid
    end
  end

  describe "send_message" do
    before :each do
      @email_student=FactoryGirl.create(:student,:email=>"abc@def.com", :phone_number=>nil)
      @group.students << @email_student
      $outbound_flocky=""
      $outbound_flocky.should_receive(:message)
    end
    it "should send emails to users without phone numbers" do
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
end
