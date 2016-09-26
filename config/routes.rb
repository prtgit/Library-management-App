Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'sessions/new'
  root 'application#home'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy'
  get    'search'   => 'users#search'
  get    'users/search'   => 'users#search_user'
  get    'rooms/search'   => 'rooms#search_room'
  get 'users/history' => 'users#get_history'
  get '/rooms/schedule_room/:id' => 'rooms#schedule_room'
  resources :bookings
  resources :rooms
  resources :users
end
