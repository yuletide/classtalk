FactoryGirl.define do
  factory :logged_message do
    sequence(:destination_phone) {|n|"%0.10d"%n }
    sequence(:message) {|n| "message_#{n}"}
  end
end
