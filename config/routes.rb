Rails.application.routes.draw do

  root 'searches#show'

  resources :pilots, only: [:index, :show]
  resources :ship_combos, only: [:index, :show]
  resources :squadrons, only: [:index, :show]

end
