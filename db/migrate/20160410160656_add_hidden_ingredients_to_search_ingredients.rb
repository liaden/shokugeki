class AddHiddenIngredientsToSearchIngredients < ActiveRecord::Migration
  def change
    add_column :search_ingredients, :hidden_ingredients_csv, :text
  end
end
