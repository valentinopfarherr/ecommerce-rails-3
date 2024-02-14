Ecommerce::Application.routes.draw do
  devise_for :users

  post '/login', to: 'auth#login'

  namespace :api do
    namespace :v1 do
      resources :statistics do
        collection do
          get :most_purchased_by_category
          get :top_revenue_by_category
          get :purchases
          get :purchases_by_granularity
        end
      end
    end

    match '*path', to: 'errors#not_found', via: :all
  end

  resources :categories do
    member do
      get :history
    end
  end

  resources :products do
    member do
      get :history
    end
  end

  resources :admins
  resources :buyers
  resources :purchases, except: [:update]

  match '*path', to: 'errors#not_found', via: :all
end
