describe RecordPairings do
  def run(r)
    RecordPairings.run!(recipe: r)
  end

  it "requires a saved recipe" do
    expect{
      RecordPairings.run!(recipe: Recipe.new)
    }.to raise_error(Mutations::ValidationException)
  end

  context "with 4-ingredient recipe" do
    let(:recipe) do
      create(:recipe, ingredients: (1..4).map { create(:ingredient) })
    end

    # pairs should look like:
    #  [["i1", "i2"], ["i1", "i3"], ["i1", "i4"], ["i2", "i3"], ["i2", "i4"], ["i3", "i4"]]

    it "creates 6 pairings" do
      expect{
        run(recipe)
      }.to change{IngredientPairing.count}.by(6)
    end

    it "sets occurrences to 1" do
      run(recipe)

      expect(IngredientPairing.pluck('DISTINCT occurrences')).to eq [1]
    end

    context "with old pairings and ingredients" do
      let(:old_ingredient) { create(:ingredient) }
      let(:old_pairing) { create(:ingredient_pairing, ingredients: [Ingredient.first, old_ingredient])}

      it "sets old pairings to 0" do
        RecordPairings.run!(recipe: recipe, previous_ingredients: [old_ingredient])
        with_old_ingredient = IngredientPairing.with_ingredient(old_ingredient)

        expect(with_old_ingredient.map(&:occurrences).uniq).to eq [0]
        expect(
          (IngredientPairing.all - with_old_ingredient.to_a).map(&:occurrences).uniq
        ).to eq [1]
      end
    end
  end
end