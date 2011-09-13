Factory.define(:logged_message) do |g|
  g.sequence(:destination_phone) {|n|"%0.10d"%n }
  g.sequence(:message) {|n| "message_#{n}"}
end
