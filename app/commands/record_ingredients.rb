class RecordIngredients < Mutations::Command
  required do
    model :recipe, new_records: true
    array :ingredients, class: String
  end

  def validate
    if ingredients.empty?
      add_error(:ingredients, :no_ingredients, "Must specify at least one ingredient for recipe")
    end
  end

  def execute
    Recipe.transaction do
      remove_old_unused_ingredients
      recipe.ingredients = create_added_ingredients
      recipe.save!
    end
  end

  private

  def remove_old_unused_ingredients
    RecipeIngredient.where(recipe_id: recipe.id, ingredient_id: removed_ingredients.map(&:id)).delete_all
  end

  def removed_ingredients
    recipe.ingredients.to_a.reject { |ingredient| new_ingredient_names.include?(ingredient.name)}
  end

  def create_added_ingredients
    added_ingredient_names.map { |name| Ingredient.find_or_create_by(name: name) }
  end

  def old_ingredient_names
    recipe.ingredients.map(&:name).to_set
  end

  def added_ingredient_names
    inputs[:ingredients].to_set - old_ingredient_names
  end

  def new_ingredient_names
    inputs[:ingredients]
  end

  def recipe
    inputs[:recipe]
  end
end