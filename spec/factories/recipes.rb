FactoryGirl.define do
  factory :recipe do
    sequence(:name) { |n| "test_recipe_#{n}" }
    sequence(:url) { |n|  "http://foodnetwork.com/recipe/test/#{n}" }
  end
end
