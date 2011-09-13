FactoryGirl.define(:user) do |u|
  u.sequence(:email) {|n| "email#{n}@testcompany.com"}
  u.password "123456"
  u.password_confirmation "123456"
  u.first_name "Dan"
  u.last_name "inator"
  u.display_name "melt-on"
end
