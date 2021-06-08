Rails.application.routes.draw do
  get 'users/index'
  get 'users/edit'
  get 'users/show'
  get 'homes/top'
  get 'homes/about'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
