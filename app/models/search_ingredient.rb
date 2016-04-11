class SearchIngredient < ActiveRecord::Base
  validates :ingredients_csv, presence: true, allow_blank: false

  def ingredient_names
    ingredients_csv.split(',')
  end

  def hidden_ingredient_names
    hidden_ingredients_csv.to_s.split(',')
  end

  def missing_ingredients
    ingredient_names - ingredients.map(&:name)
  end

  def ingredients
    @ingredients = Ingredient.where(name: ingredient_names)
  end

  def min_occurrences
    occurrences_minimum || 1
  end

  def graph
    IngredientGraph.new(self)
  end

  def reload
    @ingredients = nil
    super
  end

  def include_auxiliary_edges?
    include_auxiliary_edges
  end
  
  def self.best_hidden_ingredients
    "salt,butter,egg"
  end
end
