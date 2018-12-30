Rails.application.routes.draw do
  resources :notices
  get 'user_mailer/accout_activation'

  get 'user_mailer/password_reset'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'homes#index'
  match '/forgot', to: 'sessions#forgot', via: 'get'
  match '/forgot', to: 'sessions#send_reset_email', via: 'post'
  match '/reset', to: 'sessions#reset', via: 'get'
  match '/reset', to: 'sessions#reset_act', via: 'post'
  match '/active', to: 'sessions#send_active_email', via: 'post'
  match '/users', to: 'users#show', via: 'get'
  match '/active', to: 'sessions#active', via: 'get'
  match '/select', to: 'courses#select', via: 'get'
  # get "/list/course/" => "courses#list"

  resources :courses do
    member do
      get :quit
      get :open
      get :close
      get :set_degree
      get :cancel_degree
    end
    collection do
      get :list
      get :my_course_list
      get :credit_statistics
      post :list
    end
  end

  resources :grades, only: [:index, :update]
  resources :users
  resources :user_mailer
  get 'sessions/login' => 'sessions#new'
  post 'sessions/login' => 'sessions#create'
  delete 'sessions/logout' => 'sessions#destroy'


  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
