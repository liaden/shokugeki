class IngredientPairing < ActiveRecord::Base
  belongs_to :first_ingredient,   class_name: 'Ingredient', inverse_of: :ingredient_pairings
  belongs_to :second_ingredient,  class_name: 'Ingredient', inverse_of: :ingredient_pairings

  validates_each :ingredients do |record, attr, value|
    if record.first_ingredient && record.second_ingredient
      if record.first_ingredient.name.to_s > record.second_ingredient.name.to_s
        record.errors.add(:base, "Paired ingredients are applied out of order")
      end
    end
  end

  scope :with_ingredient, ->(ingredient) { where('first_ingredient_id = ? OR second_ingredient_id = ?', ingredient.id, ingredient.id) }
  scope :with_ingredients, ->(ing1, ing2) { where(first_ingredient_id: [ing1.id, ing2.id], second_ingredient_id: [ing1.id, ing2.id]) }

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
      first_ingredient, second_ingredient = *values
    else
      second_ingredient, first_ingredient = *values
    end
  end

  def ingredients
    [first_ingredient, second_ingredient]
  end

  private

  def all_recipe_ids_for(ingredient_id)
    RecipeIngredient.where(ingredient_id: ingredient_id).pluck(:recipe_id)
  end

  def shared_recipe_ids
    shared_recipe_ids = all_recipe_ids_for(first_ingredient_id)
      .to_set.intersection(all_recipe_ids_for(second_ingredient_id))
  end
end