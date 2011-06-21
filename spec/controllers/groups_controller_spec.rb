require 'spec_helper'

describe GroupsController do
  
  before(:each) do
    login
    @group=Factory.create(:group,:user=>controller.current_user)
    @member1 = Factory.create(:student)
    @group.students << @member1
    controller.stub(:get_new_phone_number).and_return("4443332222")
  end
  
  describe "authorization" do
    pending "all actions should be accessible to logged in users" do
    end
    pending "no actions should be accessible to non-logged-in users" do
    end
  end
  describe "#create" do
    before :each do
      login
    end
    it "after successful create, should redirect to the show page" do
      controller.should_receive(:get_new_phone_number).and_return("5556667777")
      post :create, :group=>{}
      assigns[:group].should_not be_nil
      response.should redirect_to(assigns[:group])
    end
    
    it "must belong to the logged in user" do
      post :create, :group=>{}
      assigns[:group].user.should == controller.current_user
      post :create, :group=>{:user_id=>999}
      assigns[:group].user.should == controller.current_user
    end
  end

  
  describe "boilerplate functionality" do
    describe "index" do
      it "should set @groups" do
        get :index
        assigns[:groups].should_not be_nil
      end
      pending "should be limited to currently logged in user's groups only" do
      end
    end
    
    describe "show/edit" do
      it "should set @group and a @page_title" do
        [:show,:edit].each do |meth|
          get meth, {:id=>@group.id}
          assigns[:group].should_not be_nil
          assigns[:page_title].should_not be_nil
        end
      end
      pending "should only show if it's the currently logged in user's group" do
      end
    end
    
    it "new should give us a new @group" do
      get :new
      assigns[:group].should_not be_nil
      assigns[:group].should be_new_record
    end
    describe "delete" do
      it "should delete group, and dependent students" do
        expect {
          delete :destroy, {:id=>@group.id}
        }.to change(Student,:count).by(-1)
        Group.find_by_id(@group.id).should be_nil
      end
      pending "should only delete if it's the currently logged in user's group" do
      end
      
    end
  end
  
  
  describe "#update" do
    it "can't change the user" do
      expect {
        put :update, {:id=>@group.id, :group=>{:user_id=>999}}
        @group.reload
      }.to_not change(@group,:user)
    end
    it "should create students based on passed in parameters" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]} }
      Student.find_by_name("Imma new guy").should_not be_nil #'should exist' doesn't seem to exist
      Student.find_by_name("Imma new guy").phone_number.should == "5551234567"
    end
    it "should automatically add those created students to the group" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]}}
      @group.students.count.should == 2
      @group.students.find_by_name("Imma new guy").should_not be_nil #'should exist' doesn't seem to exist
    end
    it "should not create a duplicate student in the same group, even if we forget to pass an id" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>@member1.name,:phone_number=>@member1.phone_number}]}}
      Student.find_all_by_phone_number(@member1.phone_number).count.should == 1
      @group.students.count.should == 1
    end
    it "should allow people to delete students from groups" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:id=>@member1.id,:_destroy=>'1'}]}}
      @group.reload
      @group.students.should be_empty
    end
    it "after deleting, should not have a deleted student in the assigned group's student list" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:id=>@member1.id,:_destroy=>'1'}]}}
      assigns[:group].students.should be_empty
    end
    
    it "on success, should redirect to current group's page" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]}}
      response.should redirect_to(@group)
    end
    it "on success, should have no errors" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]}}
      assigns[:group].errors.should be_empty
    end
    
    it "should not create invalid students" do
      expect {
        put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"",:phone_number=>"123"}]}}
      }.to_not change(Student,:count)
      @group.students.count.should == 1
    end
    it "should render back to edit with errors on invalid student" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"",:phone_number=>"123"}]}}
      assigns[:group].errors.should_not be_empty
    end
    
    it "should silently ignore blank entries" do
      expect {
        put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"},{:name=>"",:phone_number=>""}]}}
      }.to change(Student,:count).by(1) #as opposed to 2
      
      @group.students.count.should == 2
      assigns[:group].errors.should be_empty
    end
    
    it "should check for existing students, agnostic of original phone number input formatting" do
      expect {
        put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>@member1.name,:phone_number=>"___"+@member1.phone_number+"~~~"}]}}
      }.to_not change(Student,:count)
      @group.students.count.should == 1
    end
  end
  
  describe "bulk_update_students" do
    it "should accept a simply formatted, no-header CSV, with [name, phone, email], as a multipart-file" do
    end
    it "should add new students from CSV" do
    end
    it "should update matching names, phone numbers, or emails with new info from CSV" do
    end
    pending "should handle errors" do
    end
  end
  
  describe "send_message" do
    before :each do
      $outbound_flocky.should_receive(:message).with(@group.phone_number,/test message/,an_instance_of(Array))
    end
    
    it "should send a message to all group members" do
      post :send_message, {:id=>@group.id, :message=>{:content=>"test message"}, :commit=>"send now"}
    end
    it "should send a message delayed-like" do
      #@group.should_receive(:delay) {@group} #I don't know how to test this properly - @group here won't receive the message - createds-in-crontroller-@group inside the controller will
      post :send_message, {:id=>@group.id, :message=>{:content=>"test message"}, :commit=>"send_scheduled", :date=>{:year=>"1999",:month=>"12",:day=>"31",:hour=>"23"}}
      Delayed::Worker.new.work_off #send the delayed message
    end
    
    it "should log the message" do
      expect {
        post :send_message, {:id=>@group.id, :message=>{:content=>"test message"}, :commit=>"send now"}
      }.to change(LoggedMessage,:count).by(@group.students.count)
      LoggedMessage.last.message.should match("test message")
    end
  end
  
  describe "receive_message" do
    before :each do
      sign_out controller.current_user
    end
    
    pending "should log the message" do
    end
    
    it "should disable student if they text '#removeme'" do
      @group.students.first.phone_number.should_not be_nil
      $outbound_flocky.should_receive(:message).with(@group.phone_number,/removed/,[@group.students.first.phone_number])
      post :receive_message, {:incoming_number=>@group.phone_number, :origin_number=>@group.students.first.phone_number, :message=>"#removeme"}
      @group.students.first.phone_number.should be_nil
    end
    
    describe "if teacher does have phone number" do
      before :each do
        @group.user.phone_number = @teacher_num = "5551234567"
        @group.user.save
      end
      
      it "if sent from student, should send a message to teacher, and only the teacher" do
        @group.students << Factory.create(:student)
        $outbound_flocky.should_receive(:message).with(@group.phone_number,/goat/,[@teacher_num])
        post :receive_message, {:incoming_number=>@group.phone_number, :origin_number=>@group.students.first.phone_number, :message=>"I was told it was a giant mutant space goat!"}
      end
      
      it "if sent from teacher, should send a message to all group members" do
        $outbound_flocky.should_receive(:message).with(@group.phone_number,/moth/,@group.students.map(&:phone_number))
        post :receive_message, {:incoming_number=>@group.phone_number, :origin_number=>@teacher_num, :message=>"I'm sure it was a space moth."}
      end
    end
    describe "if teacher does not have phone number" do
      pending "is sent to email" do
      end
    end
  end
  
  describe "receive_email" do
    before :each do
      sign_out controller.current_user
      @group.user.update_attribute(:phone_number, @teacher_num="5551234567")
      @from_email="from@fromemail.com"
      @params = {"html"=>"", "from"=>@from_email,"x_to_header"=>"[\"group+1@mail.staging.classtalk.org\"]", "plain"=>"a returning message\n\nOn Thu, Jun 9, 2011 at 1:13 AM,  <group+1@mail.staging.classtalk.org> wrote:\n> user1: a testing message\n>", "disposable"=>"1", "signature"=>"05977d0872091de8114af47950ee403f", "subject"=>"Re: Update from example group", "to"=>"<group+1@mail.staging.classtalk.org>", "x_cc_header"=>"[\"user+moartest@codeforamerica.org\"]", "message"=>"Received: by bwz16 with SMTP id 16so1211960bwz.4\r\n        for <group+1@mail.staging.classtalk.org>; Thu, 09 Jun 2011 01:13:32 -0700 (PDT)\r\nMIME-Version: 1.0\r\nReceived: by 10.204.22.197 with SMTP id o5mr434729bkb.68.1307607211820; Thu,\r\n 09 Jun 2011 01:13:31 -0700 (PDT)\r\nReceived: by 10.205.65.198 with HTTP; Thu, 9 Jun 2011 01:13:31 -0700 (PDT)\r\nIn-Reply-To: <4df080925871c_13f9c87c7a1388633f@e1f5f000-4ff7-415d-b21f-afe6950e9a31.mail>\r\nReferences: <4df080925871c_13f9c87c7a1388633f@e1f5f000-4ff7-415d-b21f-afe6950e2011-06-09T08:13:34+00:00 app[web.1]: 9a31.mail>\r\nDate: Thu, 9 Jun 2011 01:13:31 -0700\r\nMessage-ID: <BANLkTind+aaGnUmfy2R2Egsy1YVysRg-Dw@mail.gmail.com>\r\nSubject: Re: Update from example group\r\nFrom: the guy <#{@from_email}>\r\nTo: group+1@mail.staging.classtalk.org\r\nCc: user+moartest@codeforamerica.org\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\na returning message\r\n\r\nOn Thu, Jun 9, 2011 at 1:13 AM,  <group+1@mail.staging.classtalk.org> wrote:\r\n> user1: a testing message\r\n>"}
      @group.students << Factory.create(:student,:email=>@student_email)
    end
    
    it "if sent from student, should send a message to teacher, and only the teacher" do
      $outbound_flocky.should_receive(:message).with(@group.phone_number,/a returning message/,[@teacher_num])
      @group.students << Factory.create(:student,:email=>@from_email)
      post :receive_email, @params
    end
    
    it "if sent from teacher, should send to whole group" do
      $outbound_flocky.should_receive(:message).with(@group.phone_number,/a returning message/,@group.students.map(&:phone_number).compact)
      @group.user.update_attribute(:email,@from_email)
      post :receive_email, @params
    end
    
    it "should strip out older messages that are being replied to" do
      @group.user.update_attribute(:email,@from_email)
      post :receive_email, @params
      LoggedMessage.last.message.should match /a returning message/
      LoggedMessage.last.message.should_not match /a testing message/
    end
    
  end
  
end
