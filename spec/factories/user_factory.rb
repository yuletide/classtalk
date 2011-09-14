FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email#{n}@testcompany.com"}
    password "123456"
    password_confirmation "123456"
    first_name "Dan"
    last_name "inator"
    display_name "melt-on"
  end
end
