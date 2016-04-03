describe Recipe do
  it "requires a name" do
    expect(build(:recipe, name: nil)).to_not be_valid
  end
end
