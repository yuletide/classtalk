FactoryGirl.define(:destination) do |g|
  g.sequence(:name) {|n| "name_#{n}"}
  g.notes "some notes"
  g.sequence(:hashtag) {|n| "hashtag_#{n}"}
end
