Rails.application.routes.draw do
  get 'styles/new'
  get 'styles/create'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'breweries#index'
  #
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  get 'places', to: 'places#index'
  post 'places', to: 'places#search'
  delete 'signout', to: 'sessions#destroy'
  #
  resources :users, :beers, :breweries, :memberships, :beer_clubs, :styles
  # get 'ratings', to: 'ratings#index'
  # get 'ratings/new', to:'ratings#new'
  # post 'ratings', to: 'ratings#create'
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
  #resources :styles, only: [:index, :show, :create, :edit, :update]
  resources :breweries do
    post 'toggle_activity', on: :member
  end

  resources :users do
    post 'toggle_closure', on: :member
  end
end
