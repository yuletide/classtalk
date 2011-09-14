require 'spec_helper'

describe "students/new.html.erb" do
  before(:each) do
    assign(:student, stub_model(Student).as_new_record)
    @group = assign(:group, FactoryGirl.create(:group))
  end

  it "renders new student form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => group_students_path(@group), :method => "post" do
    end
  end
end
