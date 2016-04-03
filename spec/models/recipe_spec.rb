describe Recipe do
  it "creates" do
    expect(create(:recipe)).to be_an_instance_of(Recipe)
  end

  describe "name" do
    it "cannot be nil" do
      expect(build(:recipe, name: nil)).to_not be_valid
    end

    it "cannot be empty" do
      expect(build(:recipe, name: '')).to_not be_valid
    end
  end

  describe "URL" do
    it "cannot be nil" do
       expect(build(:recipe, url: nil)).to_not be_valid
    end

    it "cannot be ''" do
      expect(build(:recipe, url: '')).to_not be_valid
    end
  end
end