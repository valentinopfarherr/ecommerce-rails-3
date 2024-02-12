Ecommerce::Application.routes.draw do
  devise_for :users
  post 'admin_login', to: 'admin_sessions#create'
  post 'customer_login', to: 'customer_sessions#create'

  resources :admins
  resources :buyers
  resources :categories
  resources :products
  resources :purchases, except: [:update]

  match '*path', to: 'errors#not_found'
end
