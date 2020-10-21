Rails.application.routes.draw do
  resources :profiles
  resources :reviews
  resources :comments
  resources :events
  devise_for :users, :controllers => {
    confirmations: 'users/confirmations',
    #omniauth_callbacks: 'users/omniauth_callbacks',
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

  get '/make_admin' => 'static_pages#make_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
