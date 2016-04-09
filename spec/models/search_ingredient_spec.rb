describe SearchIngredient do
  it { is_expected.to validate_presence_of :ingredients_csv }

  describe "#missing_ingredients" do
    it "returns [] when nothing is missing" do
      expect(
        create(:search_ingredient, :with_ingredient).missing_ingredients
      ).to be_empty
    end

    it "returns array of names when missing" do
      search = create(:search_ingredient)

      expect(search.missing_ingredients).to eq search.ingredient_names
    end
  end
end
