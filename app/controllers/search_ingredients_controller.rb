class SearchIngredientsController < ApplicationController
  before_action :set_default_params, only: [:create, :update]

  def new
    @search = SearchIngredient.new(hidden_ingredients_csv: SearchIngredient.best_hidden_ingredients)
  end

  def create
    graph_widget_data(SearchIngredient.create!(search_params))

    render :show
  end

  def show
    graph_widget_data(SearchIngredient.find(params[:id]))
  end

  def update
    @search = SearchIngredient.find(params[:id])
    @search.update_attributes!(search_params)

    graph_widget_data(@search)

    render :show
  end

  private

  def set_default_params
    params[:search_ingredient][:hidden_ingredients_csv] ||=  ''
    params[:search_ingredient][:include_auxiliary_edges] ||= false
  end

  def search_params
    params.require(:search_ingredient).permit(:ingredients_csv, :hidden_ingredients_csv, :occurrences_minimum, :include_auxiliary_edges)
  end
end
