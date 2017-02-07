Rails.application.routes.draw do

  root 'overviews#index'

  resources :pilots,      only: [:index, :show, :update] { resource :image, only: :show }
  resources :ships,       only: [:index, :show, :update]
  resources :ship_combos, only: [:index, :show, :update]
  resources :upgrades,    only: [:index, :show, :update] { resource :image, only: :show }
  resources :conditions,  only: []                       { resource :image, only: :show }

  resource :about, only: [:show]

end
