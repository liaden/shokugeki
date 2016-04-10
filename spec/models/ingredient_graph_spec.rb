describe IngredientGraph do
  let(:graph) { IngredientGraph.new(search) }
  let(:search) { build(:search_ingredient) }
  let(:pair) { create(:ingredient_pairing, occurrences: 2) }
  let(:zero_occurrence) { create(:ingredient_pairing, ingredients: [pair.first_ingredient, create(:ingredient, name: 'z')]) }
  let(:hidden_edge) do
    create(:ingredient_pairing, ingredients: [pair.first_ingredient, create(:ingredient, name: search.hidden_ingredient_names.first)])
  end

  describe "#edges" do
    let(:search) { build(:search_ingredient, ingredients_csv: pair.first_ingredient.name) }

    it "does not include zero occurrence pairings" do
      zero_occurrence

      expect(graph.edges).to_not include zero_occurrence
    end

    it "does not include unrelated pairings" do
      unrelated_pairing = create(:ingredient_pairing)

      expect(graph.edges).to_not include unrelated_pairing
    end

    it "does not include edges with hidden ingredients" do
      hidden_edge

      expect(graph.edges).to_not include hidden_edge
    end
  end

  describe "#edge_data" do
    let(:search) { build(:search_ingredient, ingredients_csv: pair.first_ingredient.name) }

    it "includes occurrences" do
      expect(graph.edge_data.first[:occurrences]).to eq 2
    end

    it "includes source index" do
      source_index = graph.edge_data.first[:source]

      expect([0,1]).to include source_index
    end

    it "includes target index" do
      target_index = graph.edge_data.first[:target]

      expect([0,1]).to include target_index
    end

  end

  describe "#nodes" do
    let(:search) { build(:search_ingredient, ingredients_csv: pair.first_ingredient.name) }
    let!(:unrelated) { create(:ingredient) }

    it "includes searched ingredient and related ingredient only" do
      expect(graph.nodes).to contain_exactly(*pair.ingredients)
    end

    it "does not include zero occurrence related nodes" do
      zero_occurrence

      expect(graph.nodes).to_not include zero_occurrence.second_ingredient
    end

    it "does not include hidden nodes" do
      hidden_edge
      hidden_node = Ingredient.find(search.hidden_ingredient_names.first)

      expect(graph.nodes).to_not include hidden_node
    end
  end

  describe "#node_data" do
    let(:node) do
      n = build(:ingredient)
      allow(n).to receive(:recipes_count).and_return(2)
      n
    end

    before { allow(graph).to receive(:nodes).and_return([node]) }

    it "includes node's name" do
      expect(graph.node_data.first[:name]).to eq node.name
    end

    it "flags searched ingredients" do
      node.name = search.ingredient_names.first

      expect(graph.node_data.first[:searched]).to eq true
    end

    it "flags unsearched ingredients" do
      expect(graph.node_data.first[:searched]).to_not eq true
    end

    it "includes recipes count" do
      expect(graph.node_data.first[:recipes_count]).to_not eq 0
      expect(graph.node_data.first[:recipes_count]).to eq node.recipes_count
    end
  end
end