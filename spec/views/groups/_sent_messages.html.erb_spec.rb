require 'spec_helper'

describe "groups/_sent_messages.html.erb" do
  before(:each) do
    @group = assign(:group, FactoryGirl.create(:group))
    @messages = assign(:messages, [FactoryGirl.create(:logged_message, :message => "something we send out", :created_at => Time.parse("2011-01-01, 12:00 PM -0000"))])
    @current_user = login
  end

  it "should render without error" do
    render
  end

  it "should display the sent time, based on the user's time zone" do
    @current_user.update_attribute(:time_zone,'Eastern Time (US & Canada)')
    render
    rendered.should =~ /7:00/
    @current_user.update_attribute(:time_zone,'Pacific Time (US & Canada)')
    rendered.should =~ /4:00/
  end
end
