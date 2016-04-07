describe Ingredient do
  let(:ingredient) { create(:ingredient) }

  it "creates" do
    expect(ingredient).to be_an_instance_of(Ingredient)
  end

  it "requires a name" do
    expect(build(:ingredient, name: nil)).to_not be_valid
  end

  describe "#pairings" do
    let(:ingredient) { create(:ingredient, name: 'm') }
    let!(:other1)  { create(:ingredient_pairing, first_ingredient: ingredient, second_ingredient: create(:ingredient, name: 'z')).second_ingredient }
    let!(:other2) { create(:ingredient_pairing, first_ingredient: create(:ingredient, name: 'a'), second_ingredient: ingredient).first_ingredient }

    it "finds all paired ingredients" do
      expect(ingredient.pairings).to contain_exactly(other1, other2)
    end
  end

  describe "#recipes_count" do
    it "is zero on new ingredient" do
      expect(build(:ingredient).recipes_count).to be 0
    end

    it "is 2" do
      ingredient.recipes.create(attributes_for(:recipe))
      ingredient.recipes.create(attributes_for(:recipe))

      expect(ingredient.reload.recipes_count).to eq 2
    end
  end

  describe ".sanitized_order" do
    subject { Ingredient.sanitized_order(ordering).to_a }

    let!(:item1) { create(:ingredient, name: 'A') }
    let!(:item2) { create(:ingredient, name: 'B') }
    let!(:item3) { create(:ingredient, name: 'C') }

    let!(:recipe21) { item2.recipes.create(attributes_for(:recipe)) }
    let!(:recipe22) { item2.recipes.create(attributes_for(:recipe)) }
    let!(:recipe31) { item3.recipes.create(attributes_for(:recipe)) }

    context "ordering is nil" do
      let(:ordering) { nil }

      it "uses alphabetical" do
        is_expected.to contain_exactly(item1, item2, item3)
      end
    end

    context "ordering is popularity" do
      let(:ordering) { :popularity }

      it { is_expected.to contain_exactly(item2, item3, item1)}
    end

    context "ordering is rarity" do
      let(:ordering) { :rarity }

      it { is_expected.to contain_exactly(item1, item3, item2) }
    end
  end
end