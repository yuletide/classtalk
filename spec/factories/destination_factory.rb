FactoryGirl.define do
  factory :destination do
    sequence(:name) {|n| "name_#{n}"}
    notes "some notes"
    sequence(:hashtag) {|n| "hashtag_#{n}"}
  end
end
