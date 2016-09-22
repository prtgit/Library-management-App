Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'sessions/new'
  root 'application#home'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy'
  get    'search'   => 'users#search'
  get    'users/search'   => 'users#search_user'
  resources :bookings
  resources :rooms
  resources :users
end
