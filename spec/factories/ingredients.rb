FactoryGirl.define do
  factory :ingredient do
    sequence(:name) { |n| "test_%04d" % n }

    trait :with_recipe do
      recipes { [build(:recipe)] }
    end
  end
end