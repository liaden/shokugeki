describe RecipeIngredient do
  it "creates" do
    expect(create(:recipe_ingredient)).to be_an_instance_of(RecipeIngredient)
  end

  it "requires recipe_id" do
    expect(build(:recipe_ingredient, recipe_id: nil)).to_not be_valid
  end

  it "requires ingredient_id" do
    expect(build(:recipe_ingredient, ingredient_id: nil)).to_not be_valid
  end
end
