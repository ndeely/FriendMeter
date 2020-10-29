Rails.application.routes.draw do
  resources :notifications
  resources :friends
  resources :profiles
  resources :reviews
  resources :comments
  resources :events
  devise_for :users, :controllers => {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }
  #set homepage and static pages
  root 'static_pages#home'
  get '/help' => 'static_pages#help' 
  get '/about' => 'static_pages#about'
  get '/users' => 'static_pages#allusers'

  get '/admin' => 'static_pages#admin'

  get '/users/:id' => 'static_pages#profile'
  get '/upgrade/:id' => 'static_pages#upgrade'
  get '/downgrade/:id' => 'static_pages#downgrade'
  get '/prem/:id' => 'static_pages#prem'
  get '/notprem/:id' => 'static_pages#notprem'

  get '/make_admin' => 'static_pages#make_admin'
end
