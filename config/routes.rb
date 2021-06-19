Rails.application.routes.draw do
  root 'homes#top'
  post '/' => 'homes#top'
  get '/about' => 'homes#about'
  devise_for :users,only: [:omniauth_callback] , controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  devise_scope :user do
    delete 'users/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
  end
  get '/ranking' => 'users#index', as: :users
  resources :users,only: [:show,:edit,:update] do
    get 'follows' => 'users#follows', as: 'follows'    
    get 'followers' => 'users#followers', as: 'followers'    
  end
  post 'follow/:id' => 'relationships#follow', as: 'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resource :reports, only: [:create]
  end
  resources :notifications, only: :index
end
