FactoryGirl.define do
  factory :ingredient do
    sequence(:name) { |n| "test_#{n}" }

    trait :with_recipe do
      recipes { [build(:recipe)] }
    end
  end
end