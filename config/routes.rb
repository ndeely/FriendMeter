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
  get '/users' => 'static_pages#users'
  get '/about' => 'static_pages#about'

  #set admin pages
  get '/users' => 'admin_pages#allusers'
  get '/admin' => 'admin_pages#admin'
  #create admins and premium users
  get '/upgrade/:id' => 'admin_pages#upgrade'
  get '/downgrade/:id' => 'admin_pages#downgrade'
  get '/prem/:id' => 'admin_pages#prem'
  get '/notprem/:id' => 'admin_pages#notprem'

  #profile
  get '/users/:id' => 'profiles#profile' #user profile
  get '/users/:id/:id2' => 'profiles#friend' #friend request
  get '/users/:id/:id2/1' => 'profiles#unfriend' #unfriend
  get '/user/:uid/reviews' => 'profiles#reviews' #user reviews
  

  #notifications
  get '/notifications/:id/1' => 'notifications#acceptFriend' #accept friend request
  get '/notifications/:id/3' => 'notifications#acceptEvent' #accept event invite from notifications
  get '/notifications/:uid/9' => 'notifications#deleteAll' #delete all notifications for current user
  get '/notifications/:eid/8' => 'notifications#deleteForEvent' #delete all notifications related to event for current user

  #attend event or send invite
  get '/events/:eid/1' => 'events#attend' #agree to attend event from event
  get '/events/:eid/2' => 'events#unattend' #unattend event from event
  get '/events/:eid/:uid/1' => 'events#invite' #send event invite
  get '/events/:eid/:uid/2' => 'events#acceptInvite' #accept event invite

  #get user events, or events where user is invited or is attending
  get '/myevents' => 'events#myevents'

  #payment routes
  get '/orders' => 'orders#index'
  post '/orders/submit' => 'orders#submit'
  get '/orders/all' => 'orders#all'

  post 'orders/paypal/create_payment'  => 'orders#paypal_create_payment', as: :paypal_create_payment
  post 'orders/paypal/execute_payment'  => 'orders#paypal_execute_payment', as: :paypal_execute_payment

  

  get '/make_admin' => 'admin_pages#make_admin'
end
