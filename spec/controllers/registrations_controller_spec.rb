require 'spec_helper'

describe RegistrationsController do
  
  before(:each) do
     @current_user = login
  end
  
  describe "dont show notification" do
    it "when you post to it, should set the notification variable" do
      request.env["HTTP_REFERER"] = "mypage"
      put :dont_show_again, {:notification_name => "group_number_popup"}
      @current_user.reload.show_group_number_popup?.should be_false
    end
  end
  
end