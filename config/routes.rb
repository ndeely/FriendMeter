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

  #set admin pages
  get '/users' => 'admin_pages#allusers'
  get '/admin' => 'admin_pages#admin'

  get '/users/:id' => 'profiles#profile'
  get '/users/:id/:id2' => 'profiles#profile'
  get '/notifications/:id/1' => 'notifications#acceptFriend' #accept friend request
  get '/notifications/:id/3' => 'notifications#acceptEvent' #accept event invite from notifications
  get '/events/:eid/1' => 'events#attend' #accept event invite from event
  get '/events/:eid/:uid/1' => 'events#invite' #send event invite
  get '/upgrade/:id' => 'admin_pages#upgrade'
  get '/downgrade/:id' => 'admin_pages#downgrade'
  get '/prem/:id' => 'admin_pages#prem'
  get '/notprem/:id' => 'admin_pages#notprem'

  get '/make_admin' => 'admin_pages#make_admin'
end
