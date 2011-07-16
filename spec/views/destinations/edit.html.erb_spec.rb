require 'spec_helper'

describe "destinations/edit.html.erb" do
  before(:each) do
    @destination = assign(:destination, stub_model(Destination))
  end

  it "renders the edit destination form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => destinations_path(@destination), :method => "post" do
    end
  end
end
