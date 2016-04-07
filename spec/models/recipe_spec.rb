describe Recipe do
  it "creates" do
    expect(create(:recipe)).to be_an_instance_of(Recipe)
  end

  describe "#name" do
    it { is_expected. to validate_presence_of :name }

    it "cannot be empty" do
      expect(build(:recipe, name: '')).to_not be_valid
    end
  end

  describe "#url" do
    it { is_expected.to validate_presence_of :url }

    it "cannot be empty" do
      expect(build(:recipe, url: '')).to_not be_valid
    end
  end

  it { is_expected.to have_many(:ingredients) }

  describe "#recipe_ingredients" do
    it { is_expected.to have_many(:recipe_ingredients) }

    it "destroys associated recipe_ingredients on delete" do
      recipe = create(:recipe, :with_ingredient)

      recipe.destroy

      expect(RecipeIngredient.count).to eq 0
      expect(Ingredient.count).to eq 1
    end
  end
end