Rails.application.routes.draw do

  root 'overviews#index'

  resources :pilots, only: [:index, :show]
  resources :ships, only: [:index]
  resources :ship_combos, only: [:index, :show]
  resources :squadrons, only: [:index, :show]

  resource :about, only: [:show]

end
