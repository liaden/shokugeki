class IngredientPairing < ActiveRecord::Base
  belongs_to :first_ingredient,   class_name: 'Ingredient'
  belongs_to :second_ingredient,  class_name: 'Ingredient'

  validates_each :ingredients do |record|
    if record.first_ingredient && record.second_ingredient
      if record.first_ingredient.name.to_s > record.second_ingredient.name.to_s
        record.errors.add(:base, "Paired ingredients are applied out of order")
      end
    end
  end

  scope :with_ingredient, ->(ingredient) { where('first_ingredient_id = ? OR second_ingredient_id = ?', ingredient.id, ingredient.id) }
  scope :with_ingredients, ->(ing1, ing2) { where(first_ingredient_id: [ing1.id, ing2.id], second_ingredient_id: [ing1.id, ing2.id]).first }
  scope :within_ingredients, ->(ingredients) { where(first_ingredient_id: ingredients.map(&:id), second_ingredient_id: ingredients.map(&:id)) }
  scope :including_ingredients, ->() { includes(:first_ingredient).includes(:second_ingredient) }
  scope :by_names, ->(names) {
    joins(:first_ingredient).joins(:second_ingredient)
      .where('"ingredients"."name" IN (?) OR "second_ingredients_ingredient_pairings"."name" IN (?)', Array(names), Array(names))
  }

  def recompute_occurrences
    raise "Both ingredients must be persisted" unless first_ingredient_id && second_ingredient_id

    self.occurrences = shared_recipe_ids.size
  end

  def shared_recipes
    Recipes.where(id: shared_recipe_ids)
  end

  def ingredients=(values)
    raise ArgumentError.new("Wrong numer of ingredients for pairing: #{values.size}") if values.size != 2

    if values.first.name < values.second.name
      self.first_ingredient, self.second_ingredient = *values
    else
      self.second_ingredient, self.first_ingredient = *values
    end
  end

  def ingredients
    [first_ingredient, second_ingredient]
  end

  def ingredient_names
    [first_ingredient.name, second_ingredient.name]
  end

  def data
    [first_ingredient.name, second_ingredient.name, occurrences]
  end

  private

  def all_recipe_ids_for(ingredient_id)
    RecipeIngredient.where(ingredient_id: ingredient_id).pluck(:recipe_id)
  end

  def shared_recipe_ids
    all_recipe_ids_for(first_ingredient_id)
      .to_set.intersection(all_recipe_ids_for(second_ingredient_id))
  end
end