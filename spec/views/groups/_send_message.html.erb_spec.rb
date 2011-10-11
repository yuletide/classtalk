require 'spec_helper'

describe "groups/_send_message.html.erb" do
  before(:each) do
    @group = assign(:group, FactoryGirl.create(:group))
    @current_user = login
  end

  it "should render without error" do
    render
  end

  it "should inform the user of who replies will be sent to" do
    @group.replies_all = false
    render
    rendered.should =~ /replies will be returned only to you/
    @group.replies_all = true
    render
    rendered.should =~ /replies will be forwarded to you, and all group members/
  end
end