Rails.application.routes.draw do
  resources :ingredients, only: [:index, :show]
  resources :recipes, except: :destroy
  resources :search_ingredients, only: [:new, :show, :create, :update]
end
