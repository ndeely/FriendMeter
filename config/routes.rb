Rails.application.routes.draw do
  resources :attendings
  resources :invites
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
  get '/users/:id/:id2' => 'static_pages#profile'
  get '/notifications/:id/1' => 'notifications#accept' #accept friend request
  get '/notifications/:id/3' => 'notifications#invite' #accept event invite
  get '/events/:id/1' => 'events#attend' #accept event invite
  get '/events/:id/:id2/1' => 'events#invite' #send event invite
  get '/upgrade/:id' => 'static_pages#upgrade'
  get '/downgrade/:id' => 'static_pages#downgrade'
  get '/prem/:id' => 'static_pages#prem'
  get '/notprem/:id' => 'static_pages#notprem'

  get '/make_admin' => 'static_pages#make_admin'
end
