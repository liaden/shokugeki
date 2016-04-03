FactoryGirl.define do
  factory :recipe_ingredient do
    recipe { create(:recipe) }
    ingredient { create(:ingredient) }
  end
end
