class SearchIngredientsController < ApplicationController
  #skip_before_action :verify_authenticity_token

  def create
    @search = SearchIngredient.find_or_create_by(ingredients_csv: search_params[:ingredients_csv])
    @graph = @search.graph

    gon_data_and_response(@graph)
  end

  def show
    @search = SearchIngredient.find(params[:id])
    @graph = @search.graph

    gon_data_and_response(@graph)
  end

  private

  def search_params
    params.require(:search_ingredient).permit(:ingredients_csv)
  end

  def gon_data_and_response(graph)
    gon.edges = graph.edge_data
    gon.nodes = graph.node_data

    render :show
  end
end
