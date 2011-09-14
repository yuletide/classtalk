FactoryGirl.define do
  factory :group do
    sequence(:title) {|n| "group_number_#{n}"}
    sequence(:phone_number) {|n|"%0.10d"%n }
    sequence(:destination_phone_number) {|n| ("%0.10d"%n).reverse }
    association :user
  end
end
