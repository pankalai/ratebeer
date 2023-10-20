Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'breweries#index'
  #
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  #
  resources :users, :beers, :breweries, :memberships, :beer_clubs
  # get 'ratings', to: 'ratings#index'
  # get 'ratings/new', to:'ratings#new'
  # post 'ratings', to: 'ratings#create'
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
end
