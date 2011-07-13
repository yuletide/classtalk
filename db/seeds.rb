# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Admin.create(:email => "admin@codeforamerica.org", :password => "password", :password_confirmation => "password")
User.create(:email => "demo@codeforamerica.org", :password => "password", :password_confirmation => "password")

puts "Success! Admin 'admin@codeforamerica.org' and User 'demo@codeforamerica.org' have been created. Default password is 'password'. You should change it now."