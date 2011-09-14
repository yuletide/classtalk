require 'spec_helper'

describe "destinations/_list_element.erb" do
  before(:each) do
    @destination = assign(:destination, stub_model(Destination))
    @group = assign(:group, FactoryGirl.create(:group))
  end

  it "renders" do
    render :partial => "destinations/list_element.erb", :locals => {:list_element=>@destination}
  end
end
