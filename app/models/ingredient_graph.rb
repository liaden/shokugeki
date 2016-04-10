class IngredientGraph
  def initialize(search)
    @search = search
    @edges = build_edges
    @nodes = build_nodes
    @searched_ingredient_names = @search.ingredient_names.to_set
    @edges += auxiliary_edges if @search.include_auxiliary_edges?
  end

  attr_reader :edges, :nodes

  def edge_data
    edges.map do |edge|
      {
        source: node_index(edge.first_ingredient.name),
        target: node_index(edge.second_ingredient.name),
        occurrences: edge.occurrences,
        link_type: auxiliary?(edge) ? "auxiliary" : "primary"
       }
    end
  end

  def node_data
    nodes.map do |node|
      {
        name: node.name,
        searched: @search.ingredient_names.include?(node.name),
        recipes_count: node.recipes_count
      }
    end
  end

  private

  def node_index(name)
    nodes.find_index { |n| n.name == name}
  end

  def build_edges
    edges = IngredientPairing
      .where('occurrences >= ?', @search.min_occurrences)
      .including_ingredients
      .by_names(@search.ingredient_names)

    hidden_ingredients = @search.hidden_ingredient_names.to_set

    edges.to_a.reject do |edge|
      hidden_ingredients.intersect?(edge.ingredient_names.to_set)
    end
  end

  def build_nodes
    edges.flat_map(&:ingredients).uniq
  end

  def auxiliary_edges
    IngredientPairing
      .where('occurrences >= ?', [@search.min_occurrences,2].max)
      .within_ingredients(nodes - @search.ingredients)
  end

  def auxiliary?(edge)
    !@searched_ingredient_names.intersect?(edge.ingredient_names.to_set)
  end
end