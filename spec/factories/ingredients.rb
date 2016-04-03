FactoryGirl.define do
  factory :ingredient do
    sequence(:name) { |n| "test_#{n}" }
  end
end