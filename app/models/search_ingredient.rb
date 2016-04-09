class SearchIngredient < ActiveRecord::Base
  validates :ingredients_csv, presence: true, allow_blank: false

  def ingredient_names
    ingredients_csv.split(',')
  end

  def ingredient_names=(values)
    ingredients.map(&:strip).join(',')
  end

  def missing_ingredients
    ingredient_names - ingredients.map(&:name)
  end

  def ingredients
    @ingredients = Ingredient.where(name: ingredient_names)
  end

  def graph
    IngredientGraph.new(self)
  end

  def reload
    super
    @ingredients = nil
  end
end
