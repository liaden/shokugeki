FactoryGirl.define do
  factory :search_ingredient do
    ingredients_csv "searched_ingredient"
    hidden_ingredients_csv "hidden_ingredient"
    occurrences_minimum 1

    trait :with_ingredient do
      after(:create) do |search|
        create(:ingredient, name: search.ingredient_names.first)
      end
    end
  end
end
