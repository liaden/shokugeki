describe Ingredient do
  it "creates" do
    expect(create(:ingredient)).to be_an_instance_of(Ingredient)
  end
  
  it "requires a name" do
    expect(build(:ingredient, name: nil)).to_not be_valid
  end
end