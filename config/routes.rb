Rails.application.routes.draw do

  root 'overviews#index'

  resources :pilots,      only: [:index, :show, :update]
  resources :ships,       only: [:index, :show, :update]
  resources :ship_combos, only: [:index, :show, :update]
  resources :upgrades,    only: [:index, :show, :update]

  resource :about, only: [:show]

end
