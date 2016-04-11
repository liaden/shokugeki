class IngredientsController < ApplicationController
  def show
    @ingredient = Ingredient.find(params[:id])

    graph_widget_data(
      SearchIngredient.new(ingredients_csv: @ingredient.name, include_auxiliary_edges: true))
  end

  def index
    @ingredients = Ingredient.sanitized_order(params[:order])
  end
end
