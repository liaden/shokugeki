class AddIncludeAuxiliaryEdgesToSearchIngredients < ActiveRecord::Migration
  def change
    add_column :search_ingredients, :include_auxiliary_edges, :boolean, default: false
  end
end
