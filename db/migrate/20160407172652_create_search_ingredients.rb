class CreateSearchIngredients < ActiveRecord::Migration
  def change
    create_table :search_ingredients do |t|
      t.text :ingredients_csv

      t.timestamps null: false
    end
  end
end
