FactoryGirl.define(:question) do |g|
  g.sequence(:content) {|n| "question_content_#{n}"}
  g.sequence(:order_index) {|n| n}
end
