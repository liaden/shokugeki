describe SearchIngredientsController do
  render_views

  let(:search) { create(:search_ingredient, :with_ingredient) }

  describe "#create" do
    let(:params) { { ingredients_csv: "test_salt" } }

    it "returns http success" do
      post :create, search_ingredient: params

      expect(response).to have_http_status(:success)
    end

    it "saves search object" do
      expect {
        post :create, search_ingredient: params
      }.to change{SearchIngredient.count}.by(1)
    end
  end

  describe "#show" do
    it "returns http success" do
      get :show, id: search.id

      expect(response).to have_http_status(:success)
    end
  end
end