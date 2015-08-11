Rails.application.routes.draw do

  root "top#index"

  resources :users, :except => [:index, :destroy]
  get 'users/:id/photos', to: "users#photos", as: "user_photos"

  get 'session/index'
  post 'session/login'
  get 'session/logout'

  resources :bus_stops, :except => [:destroy]
  get 'bus_stops/:id/photos/new', to: "bus_stops#photos_new", as: "new_bus_stop_photos"
  post 'bus_stops/:id/photos/create', to: "bus_stops#photos_create", as: "bus_stop_photos"
  delete 'bus_stops/:id/photos/:photo_id', to: "bus_stops#photos_destroy", as: "destroy_bus_stop_photos"

  namespace :admin do
    get 'top/index'

    get 'bus_stops/', to: "bus_stops#index"
    get 'bus_stops/:id', to: "bus_stops#show", as: "bus_stop"
    delete 'bus_stops/:id/photos_destroy/:photo_id', to: "bus_stops#photos_destroy", as: "destroy_bus_stop_photos"
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
