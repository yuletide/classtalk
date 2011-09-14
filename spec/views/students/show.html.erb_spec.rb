require 'spec_helper'

describe "students/show.html.erb" do
  before(:each) do
    @student = assign(:student, stub_model(Student))
    @group = assign(:group, FactoryGirl.create(:group))
    assign(:grouped_answers, {FactoryGirl.create(:destination) => [stub_model(Answer)]})
  end

  it "renders attributes in <p>" do
    render
  end
end
