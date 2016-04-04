Rails.application.routes.draw do
  resources :ingredients, only: [:index, :show]
  resources :recipes, except: :destroy
end
