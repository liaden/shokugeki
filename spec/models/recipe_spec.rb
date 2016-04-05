describe Recipe do
  it "creates" do
    expect(create(:recipe)).to be_an_instance_of(Recipe)
  end

  describe "#name" do
    it "cannot be nil" do
      expect(build(:recipe, name: nil)).to_not be_valid
    end

    it "cannot be empty" do
      expect(build(:recipe, name: '')).to_not be_valid
    end
  end

  describe "#url" do
    it "cannot be nil" do
       expect(build(:recipe, url: nil)).to_not be_valid
    end

    it "cannot be ''" do
      expect(build(:recipe, url: '')).to_not be_valid
    end
  end

  describe "#recipe_ingredients" do
    it "destroys associated recipe_ingredients on delete" do
      recipe = create(:recipe, :with_ingredient)

      recipe.destroy

      expect(RecipeIngredient.count).to eq 0
      expect(Ingredient.count).to eq 1
    end
  end
end