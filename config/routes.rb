Wikiwar::Application.routes.draw do

  get "logout" => "users#logout", :as => "logout"
  get "login" => "users#sign_in", :as => "login"
  post "login" => "users#login", :as => "login"
  get "signup" => "users#new", :as => "signup"
  post "signup" => "users#create", :as => "signup"

  get "forgot_password" => "users#forgot_password"
  put "forgot_password" => "users#send_password_reset_instructions"

  get "password_reset" => "users#password_reset"
  put "password_reset" => "users#new_password"

  get "update_account" => "users#edit", :as => "update_account"
  put "update_account" => "users#update", :as => "update_account"
  get "statistics" => "users#statistics", :as => "statistics"
  get "ranking" => "users#ranking", :as => "ranking"

  get "singleplayer" => "singleplayer_game#index", :as => "singleplayer"
  get "singleplayergame" => "singleplayer_game#game", :as => "singleplayergame"
  post "singleplayergame" => "singleplayer_game#game_next", :as => "singleplayergame"
  
  get "multiplayer" => "multiplayer_game#index", :as => "multiplayer"

  get "about" => "welcome#about", :as => "about"
  root :to => "welcome#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
