class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def graph_widget_data(search)
    @search = search
    @graph = search.graph
    gon.edges = @graph.edge_data
    gon.nodes = @graph.node_data
  end
end
