Rails.application.routes.draw do

  get 'stats/counts' => 'stats#counts'
  get 'stats/statistiken' => 'stats#statistics'

  post 'subscriptions/create'
  delete 'subscriptions/destroy'
  get 'subscription/confirm/:confirmation_token' => 'subscriptions#confirm', as: 'subscriptions_confirm'
  get 'subscription/unsubscribe/:item_type/:unsubscribe_token' => 'subscriptions#destroy', as: 'subscriptions_unsubscribe'
  delete 'subscription/unsubscribe' => 'subscriptions#unsubscribe_user', as: 'subscriptions_unsubscribe_user'

  get 'users/items'

  get 'reactivate/:token' => 'item_reactivation#reactivate', as: 'reactivate'

  get 'welcome/index'
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => {confirmations: 'confirmations'}

  resources :offers do
    member do
      put :toggle_active
      get :owner_show
      post :request_owner_link
    end
  end

  resources :requests do
    member do
      put :toggle_active
      get :owner_show
    end
  end

  resources :answers, only: [:create]

  # Error handling
  get '/404' => redirect('/errors/404')
  get '/422' => redirect('/errors/422')
  get '/500' => redirect('/errors/500')
  get '/errors/:error_code', to: 'errors#error'

  root to: 'welcome#index'
end
