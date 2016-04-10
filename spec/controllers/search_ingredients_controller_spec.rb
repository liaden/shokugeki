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

    it "shows update form" do
      get :show, id: search.id

      expect(response.body).to include('Refine Search')
    end
  end

  describe "#update" do
    before { search.save! }

    it "saves occurrences_minimum" do
      post :update, id: search.id, search_ingredient: { occurrences_minimum: 5 }

      search.reload
      expect(search.reload.occurrences_minimum).to eq 5
    end

     it "saves hidden_ingredients" do
       post :update, id: search.id, search_ingredient: { hidden_ingredients_csv: "a,b" }

       expect(search.reload.hidden_ingredients_csv).to eq "a,b"
     end
  end
end