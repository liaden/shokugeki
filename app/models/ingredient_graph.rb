class IngredientGraph
  def initialize(search)
    @search = search
  end

  def edges
    @edges ||= build_edges
  end

  def edge_data
    edges.map do |edge|
      {
        source: node_index(edge.first_ingredient.name),
        target: node_index(edge.second_ingredient.name),
        occurrences: edge.occurrences
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

  def nodes
    @nodes ||= edges.flat_map(&:ingredients).uniq
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
end