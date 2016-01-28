Rails.application.routes.draw do

  get 'static_contents/photo_guideline'
  get 'static_contents/terms_of_service'
  #get 'static_contents/about'

  get 'bus_route_information/edit'

  get 'bus_route_information/update'

  root "top#index"

  #resources :users, :except => [:index, :destroy]
  devise_for :users, :controllers => {
      :confirmations => 'users/confirmations',
      :registrations => 'users/registrations',
      :passwords => 'users/passwords'
  }, :skip => [:sessions]
  get 'users/confirmed', to: "users#confirmed"
  as :user do
    get 'sign_in' => 'devise/sessions#new', :as => :new_user_session
    post 'sign_in' => 'devise/sessions#create', :as => :user_session
    delete 'sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get 'users/:id', to: "users#show", as: "user"
  get 'users/:id/photos', to: "users#photos", as: "user_photos"

  resources :bus_stops, :except => [:destroy]
  get 'bus_stops/:id/photos/new', to: "bus_stops#photos_new", as: "new_bus_stop_photos"
  post 'bus_stops/:id/photos/create', to: "bus_stops#photos_create", as: "bus_stop_photos"
  delete 'bus_stops/:id/photos/:photo_id', to: "bus_stops#photos_destroy", as: "destroy_bus_stop_photos"

  resources :bus_route_information, :only => [:show, :edit, :update]

  namespace :admin do
    get 'top/index'

    get 'bus_stops/', to: "bus_stops#index"
    get 'bus_stops/:id', to: "bus_stops#show", as: "bus_stop"
    delete 'bus_stops/:id', to: "bus_stops#destroy", as: "destroy_bus_stop"
    delete 'bus_stops/:id/photos_destroy/:photo_id', to: "bus_stops#photos_destroy", as: "destroy_bus_stop_photos"

    get 'photos/index'
    get 'photos/reporting', to: "photos#reporting"
    patch 'photos/reset/:id', to: "photos#reset_reporting", as: "reset_reporting"

    get 'users/index', to: "users#index", as: "users"
    get 'users/:id', to: "users#show", as: "user"
    get 'users/:id/edit', to: "users#edit", as: "edit_user"
    patch 'users/:id', to: "users#update"
    delete 'users/:id', to: "users#destroy", as: "destroy_user"
    get 'users/:id/photos', to: "users#photos_index", as: "user_photos"

  end

  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        sessions: 'devise_token_auth_overrides/sessions',
        registrations: 'devise_token_auth_overrides/registrations'
    }
  end
  mount API::Base => '/'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
