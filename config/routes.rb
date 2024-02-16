Ecommerce::Application.routes.draw do
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
  resources :users
  resources :purchases, except: [:update]
  resources :sessions, only: [:create]
end
