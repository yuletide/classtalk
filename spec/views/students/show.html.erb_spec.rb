require 'spec_helper'

describe "students/show.html.erb" do
  before(:each) do
    @student = assign(:student, stub_model(Student))
    @group = assign(:group, Factory.create(:group))
  end

  it "renders attributes in <p>" do
    render
  end
end
