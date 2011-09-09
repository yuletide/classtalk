require 'spec_helper'

describe "students/index.html.erb" do
  before(:each) do
    assign(:students, [
      stub_model(Student),
      stub_model(Student)
    ])
    @group = assign(:group, Factory.create(:group))
  end

  it "renders a list of students" do
    render
  end
end
