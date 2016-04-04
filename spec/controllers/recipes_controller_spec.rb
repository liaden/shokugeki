describe RecipesController do
  render_views

  describe "#index" do
    before { }
  end

  describe "#new" do
    it "renders form" do
      get :new

      expect(response.body).to include "recipe_ingredients_csv"
      expect(response.body).to include "recipe_name"
      expect(response.body).to include "recipe_url"
    end
  end

  describe "#create" do
    let(:params) do
      { recipe: { name: 'test', url: 'fake_url', ingredients_csv: ingredients_csv } }
    end

    let(:ingredients_csv) { 'i1,i2,i3' }

    it "saves recipe" do
      expect {post :create, params}.to change{ Recipe.count }.by(1)
    end

    it "saves ingredients" do
      expect {post :create, params}.to change{ Ingredient.count}.by(3)
    end

    context "bad data" do
      let(:ingredients_csv) { '' }

      it "saves nothing with bad data" do
        expect{post :create, params}.to_not change{[Ingredient.count, Recipe.count]}
      end

      it "shows error on form" do
        post :create, params
        expect(response.body).to include I18n.t("simple_form.errors.recipe.no_ingredients")
      end
    end

    context "unsanitized data" do
      let(:ingredients_csv) { 'i1, i2,i3'}

      it "sanitizes data" do
        post :create, params

        expect(Ingredient.find('i2')).to_not be_nil
      end
    end
  end

  describe "#edit" do
    let(:recipe) { create(:recipe, :with_ingredient) }
    let(:ingredient) { recipe.ingredients.first }

    it "shows ingredients_csv" do
      get :edit, id: recipe.id

      expect(response.body).to include ingredient.name
    end
  end

  describe "#update" do
  end
end
