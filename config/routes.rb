Rails.application.routes.draw do

  post 'subscription/create'
  delete 'subscription/destroy'
  get 'subscription/activate/:confirmation_token' => 'subscription#activate', as: 'subscription_activate'
  get 'subscription/sign_off/:item_type/:email' => 'subscription#sign_off', as: 'subscription_sign_off', :constraints => { :email => /.+@.+\..+/ }

  get 'users/items'

  get 'reactivate/:token' => 'item_reactivation#reactivate', as: 'reactivate'

  get 'welcome/index'
  ActiveAdmin.routes(self)

  devise_for :users
  resources :offers
  resources :requests

  resources :answers, only: [:create]

  # Error handling
  get '/404' => redirect('/errors/404')
  get '/422' => redirect('/errors/422')
  get '/500' => redirect('/errors/500')
  get '/errors/:error_code', to: 'errors#error'

  root to: 'welcome#index'
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
