require 'spec_helper'

describe "destinations/show.html.erb" do
  before(:each) do
    @destination = assign(:destination, stub_model(Destination))
    @group = assign(:group, Factory.create(:group))
    @groups = assign(:groups, [@group])
  end

  it "renders attributes in <p>" do
    render
  end
end
