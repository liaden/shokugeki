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

    it "does not include edges below minimum_occurrences threshold" do
      search.occurrences_minimum = 5

      expect(graph.edges).to be_empty
    end

    context "including auxiliary edges" do
      let(:searched_ingredient) { create(:ingredient, name: 'a.searched') }
      let(:other1) { create(:ingredient, name: 'other1') }
      let(:other2) { create(:ingredient, name: 'other2') }

      let!(:pairing1) { create(:ingredient_pairing, occurrences: 1, ingredients: [searched_ingredient, other1]) }
      let!(:pairing2) { create(:ingredient_pairing, occurrences: 1, ingredients: [searched_ingredient, other2]) }
      let!(:auxiliary_edge) { create(:ingredient_pairing, occurrences: 2, ingredients: [other1, other2]) }

      let(:search) { create(:search_ingredient, ingredients_csv: searched_ingredient.name, include_auxiliary_edges: true) }

      it "includes qualify auxiliary edges" do
        expect(graph.edges).to contain_exactly(pairing1, pairing2, auxiliary_edge)
      end

      it "does not include hidden ingredinets auxiliary edges" do
        search.hidden_ingredients_csv = other2.name

        expect(graph.edges).to_not include auxiliary_edge
      end

      it "does not include auxiliary edges with below minimum occurrences threshold" do
        auxiliary_edge.update_attributes(occurrences: 0)

        expect(graph.edges).to_not include auxiliary_edge
      end

      it "does not pick up dangling edges" do
        dangling = create(:ingredient_pairing, occurrences: 1, ingredients: [other2, create(:ingredient)])

        expect(graph.edges).to_not include dangling
      end
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