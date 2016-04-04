class AddRecipesCountToIngredient < ActiveRecord::Migration
  def change
    add_column :ingredients, :recipe_ingredients_count, :integer, default: 0
  end
end
