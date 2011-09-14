FactoryGirl.define do
  factory :question do
    sequence(:content) {|n| "question_content_#{n}"}
    sequence(:order_index) {|n| n}
  end
end
