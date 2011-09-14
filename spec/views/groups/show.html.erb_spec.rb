require 'spec_helper'

describe "groups/show.html.erb" do
  before(:each) do
    @group = assign(:group, FactoryGirl.create(:group))
    @groups = assign(:groups, [@group])
    @messages = assign(:messages, [FactoryGirl.create(:logged_message, :message => "something we send out" )])
    @current_user = login #assign(:current_user, FactoryGirl.create(:user))
  end

  it "should render without error" do
    render
  end

  it "should include the sent_message partial" do
    render
    rendered.should =~ /Sent Messages/
    rendered.should =~ /something we send out/
  end
end
