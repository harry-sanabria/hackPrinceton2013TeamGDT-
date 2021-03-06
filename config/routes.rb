GroupBuy::Application.routes.draw do
  post "venmo/charge", :as => "venmo_charge"
  get ":controller/:action", controller: /venmo/
  get "sessions/new"
  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get]
  match "/auth/facebook/callback", to: "sessions#logged_in", via: [:get]
  get "purchases/:id/join_purchase" => "purchases#join_purchase"
  get "purchases/:id/confirm" => "purchases#facebook_post_confirm", :as => "purchase_confirm_post"
  get "purchases/:id/edit_payment" => "purchases#edit_payment", :as => "purchase_edit_payment"
  post "purchases/:id/close", to: "purchases#close", :as => "close_purchase"
  post "purchases/:id/finalize", to: "purchases#finalize", :as => "finalize_purchase"
  post "purchases/:id/edit_payment_submit", to: "purchases#update_payment", :as => "purchase_edit_payment_submit"
  
  root :to => "sessions#new"

  resources :users, only: [:show]
  resources :sessions
    
  resources :purchases
  put '/purchases/:id/show', to: 'purchases#join_purchase', as: 'join_purchase'

  
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
