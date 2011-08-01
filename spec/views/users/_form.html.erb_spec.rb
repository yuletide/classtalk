require 'spec_helper'

describe "users/_form.erb" do
  before(:each) do
    @user = assign(:user, stub_model(User))
  end

  it "renders" do
    render
  end
end
