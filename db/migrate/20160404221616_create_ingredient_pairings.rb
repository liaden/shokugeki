class CreateIngredientPairings < ActiveRecord::Migration
  def change
    create_table :ingredient_pairings do |t|
      t.integer :first_ingredient_id
      t.integer :second_ingredient_id
      t.integer :occurrences

      t.timestamps null: false
    end
  end
end
