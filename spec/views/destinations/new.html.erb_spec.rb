require 'spec_helper'

describe "destinations/new.html.erb" do
  before(:each) do
    assign(:destination, stub_model(Destination).as_new_record)
    @group = assign(:group, Factory.create(:group))
  end

  it "renders new destination form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => group_destinations_path(@group), :method => "post" do
    end
  end
end
