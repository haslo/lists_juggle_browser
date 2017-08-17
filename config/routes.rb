Rails.application.routes.draw do

  root 'overviews#index'

  devise_for :users

  resources :pilots, only: [:index, :show] do
    resources :squadrons, only: [:index]
    resource :image, only: [:show]
  end
  resources :ships, only: [:index, :show] do
    resources :squadrons, only: [:index]
  end
  resources :ship_combos, only: [:index, :show, :update] do
    resources :squadrons, only: [:index]
  end
  resources :upgrades, only: [:index, :show] do
    resources :squadrons, only: [:index]
    resource :image, only: [:show]
  end
  resources :conditions, only: [] do
    resource :image, only: [:show]
  end
  resources :squadrons, only: [:show]
  resource :about, only: [:show]

  resources :squad_visualizations, only: [:show, :new, :create]

  resource :turning_test, only: [:show]

  resources :archetype_name_suggestions, only: [:index, :update]

  resource :maintenance_mode, only: [:show]

end
