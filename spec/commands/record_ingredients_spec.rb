describe RecordIngredients do
  let(:command) { RecordIngredients.run!(recipe: recipe, ingredients: ingredients) }
  let!(:recipe) { create(:recipe, ingredients: old_ingredients) }
  let(:old_ingredients) { [ create(:ingredient, name: 'ingredient_1')] }
  let(:ingredients) { ['ingredient_1'] }

  context "without a recipe" do
    let(:recipe) { nil }

    it "raises an error" do
      expect{command}.to raise_error(Mutations::ValidationException)
    end
  end

  context "with no new ingredients specified" do
    let(:ingredients) { [] }

    it "raises an error" do
      expect{command}.to raise_error(Mutations::ValidationException)
    end
  end

  context "with no old ingredients" do
    let(:old_ingredients) { [] }

    it "creates new ingredients" do
      expect{command}.to change{Ingredient.count}.by(ingredients.size)
    end
  end

  context "with unsaved recipe" do
    let!(:recipe) { build(:recipe, ingredients: old_ingredients) }

    it "saves the record" do
      expect{command}.to change{Recipe.count}.by(1)
    end
  end

  context "with old unused ingredients" do
    let(:ingredients) { ['ingredient_2']}

    def old_ingredient
      old_ingredients.first.reload
    end

    it "deletes RecipeIngredient" do
      command

      expect(RecipeIngredient.count).to eq 1
      expect(RecipeIngredient.pluck(:ingredient_id)).to_not include old_ingredient.id
    end

    it "recipes_count is reduced to 0" do
      command

      expect(old_ingredient.recipes_count).to eq 0
    end
  end

  context "without any ingredient changes" do
    def timestamps
      [ recipe.reload.updated_at, old_ingredients.map { |old| old.reload.updated_at } ]
    end

    it "is idempotent" do
      expect{command}.to_not change{timestamps}
    end
  end
end