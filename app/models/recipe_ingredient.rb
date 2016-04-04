class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient, counter_cache: true

  validates :recipe, :ingredient, presence: true
end
