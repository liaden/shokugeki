FactoryGirl.define do
  factory :ingredient_pairing do
    first_ingredient { build(:ingredient)}
    second_ingredient { build(:ingredient)}
    occurrences 0

    trait :with_shared_recipe do
      occurrences 1

      after(:create) do |pairing|
        create(:recipe, ingredients: pairing.ingredients)
      end
    end
  end
end
