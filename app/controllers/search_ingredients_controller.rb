class SearchIngredientsController < ApplicationController
  before_action :set_default_params, only: [:create, :update]

  def new
    @search = SearchIngredient.new
  end

  def create
    @search = SearchIngredient.create!(search_params)
    @graph = @search.graph

    gon_data_and_response(@graph)
  end

  def show
    @search = SearchIngredient.find(params[:id])
    @graph = @search.graph

    gon_data_and_response(@graph)
  end

  def update
    @search = SearchIngredient.find(params[:id])
    @search.update_attributes!(search_params)
    @graph = @search.graph

    gon_data_and_response(@graph)
  end

  private

  def set_default_params
    params[:search_ingredient][:hidden_ingredients_csv] ||=  ''
    params[:search_ingredient][:include_auxiliary_edges] ||= false
  end

  def search_params
    params.require(:search_ingredient).permit(:ingredients_csv, :hidden_ingredients_csv, :occurrences_minimum, :include_auxiliary_edges)
  end

  def gon_data_and_response(graph)
    gon.edges = graph.edge_data
    gon.nodes = graph.node_data

    render :show
  end
end
