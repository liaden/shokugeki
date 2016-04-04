class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient, counter_cache: true

  validates :recipe_id, :ingredient_id, presence: true
end
