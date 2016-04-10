class AddOccurrencesMinimumToSearchIngredients < ActiveRecord::Migration
  def change
    add_column :search_ingredients, :occurrences_minimum, :integer, default: 1
  end
end
