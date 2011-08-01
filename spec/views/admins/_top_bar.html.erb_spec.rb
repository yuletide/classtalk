require 'spec_helper'

describe "admins/_top_bar.html.erb" do
  before(:each) do
    @admin = assign(:admin, stub_model(Admin))
  end

  it "renders" do
    render
  end
end
