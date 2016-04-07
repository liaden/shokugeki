describe RecipeIngredient do
  it "creates" do
    expect(create(:recipe_ingredient)).to be_an_instance_of(RecipeIngredient)
  end

  it { is_expected.to validate_presence_of :recipe }
  it { is_expected.to validate_presence_of :ingredient }

  it { is_expected.to belong_to :recipe }
  it { is_expected.to belong_to :ingredient }
end
