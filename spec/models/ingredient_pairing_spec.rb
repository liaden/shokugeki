describe IngredientPairing do
  let(:ingredient_a)  { build(:ingredient, name: 'a') }
  let(:ingredient_b) { build(:ingredient, name: 'b') }

  it "requires first_ingredient.name < second_ingredient.name" do
    expect(
      build(:ingredient_pairing, first_ingredient: ingredient_b, second_ingredient: ingredient_a)
    ).to be_invalid
  end

  describe "#ingredients=" do
    let(:pairing) { build(:ingredient_pairing, ingredients: [ingredient_b, ingredient_a]) }

    it "orders ingredients alphabetically" do
      expect(pairing.first_ingredient = ingredient_a)
      expect(pairing.second_ingredient = ingredient_b)
      expect(pairing).to be_valid
    end

    [1,3].each do |n|
      it "raises if given #{n} ingredient(s)" do
        expect{
          build(:ingredient_paring, ingredients: [ingredient_a] * n)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#recompute_occurrences" do
    def recompute
      pairing.recompute_occurrences
    end


    it "raises error if ingredient_ids are nil" do
      expect{
        build(:ingredient, first_ingredient: nil).recompute_occurrences
      }.to raise_error

      expect{
        build(:ingredient, second_ingredient: nil).recompute_occurrences
      }.to raise_error
    end

    context "zero shared recipes" do
      let!(:pairing) { create(:ingredient_pairing)}

      it "assigns 0" do
        expect(recompute).to eq 0
      end

      it "assigns 1 after creating new shared recipe" do
        create(:recipe, ingredients: pairing.ingredients)

        expect(recompute).to eq 1
      end
    end

    context "one shared recipe" do
      let!(:pairing) { create(:ingredient_pairing, :with_shared_recipe)}

      it "assigns zero after deleting the recipe" do
        Recipe.first.destroy

        expect(recompute).to eq 0
      end

      context "with recipes that do not have both ingredients" do
        it "assigns 1" do
          third_ingredient = create(:ingredient)
          other_pairing1 = create(:ingredient_pairing, ingredients: [pairing.first_ingredient, third_ingredient])
          other_pairing2 = create(:ingredient_pairing, ingredients: [pairing.second_ingredient, third_ingredient])
          other_recipe1 = create(:recipe, ingredients: other_pairing1.ingredients)
          other_recipe2 = create(:recipe, ingredients: other_pairing2.ingredients)

          expect(recompute).to eq 1
        end
      end

      context "after creating a second shared recipe" do
        it "assigns 2" do
          create(:recipe, ingredients: Recipe.first.ingredients)

          expect(recompute).to eq 2
        end
      end
    end
  end

  describe "#shared_recipes" do
  end
end
