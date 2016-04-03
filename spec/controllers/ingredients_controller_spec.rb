describe IngredientsController do
  render_views

  describe "#index" do
    let!(:pepper) { create(:ingredient, name: 'pepper') }
    let!(:chicken) { create(:ingredient, name: 'chicken') }

    it "displays all ingredients" do
      get :index

      expect(response.body).to include('pepper')
      expect(response.body).to include('chicken')
    end

    it "orders them by name" do
      get :index

      trailing_text = response.body.partition('chicken').last
      expect(trailing_text).to include('pepper')
    end
  end

  describe "#show" do
    let(:ingredient) { create(:ingredient) }

    it "uses name as a slug" do
      get :show, id: ingredient.name

      expect(response.body).to include ingredient.name
    end
  end
end
