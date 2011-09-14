FactoryGirl.define do
  factory :student do
    sequence(:name) {|n| "student_barcode_number_#{n}"}
    sequence(:phone_number) {|n|"%0.10d"%n }
  end
end
