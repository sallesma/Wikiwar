Wikiwar::Application.routes.draw do

  get "logout" => "authentication#logout", :as => "logout"
  get "login" => "authentication#sign_in", :as => "login"
  post "login" => "authentication#login", :as => "login"
  get "signup" => "authentication#new", :as => "signup"
  post "signup" => "authentication#create", :as => "signup"

  get "forgot_password" => "authentication#forgot_password"
  put "forgot_password" => "authentication#send_password_reset_instructions"

  get "password_reset" => "authentication#password_reset"
  put "password_reset" => "authentication#new_password"

  get "update_account" => "users#edit", :as => "update_account"
  put "update_account" => "users#update", :as => "update_account"
  get "statistics" => "users#statistics", :as => "statistics"

  get "singleplayer" => "singleplayer_game#index", :as => "singleplayer"
  get "singleplayergame" => "singleplayer_game#game", :as => "singleplayergame"
  post "singleplayergame" => "singleplayer_game#game_next", :as => "singleplayergame"
  get "singleplayergame_resume" => "singleplayer_game#game_resume", :as => "singleplayergame_resume"
  get "singleplayergame_review" => "singleplayer_game#game_review", :as => "singleplayergame_review"
  
  get "multiplayer" => "multiplayer_game#index", :as => "multiplayer"
  get "challenge" => "multiplayer_game#challenge", :as => "challenge"
  get "challenge_accept" => "multiplayer_game#challenge_accept", :as => "challenge_accept"
  get "challenge_refuse" => "multiplayer_game#challenge_refuse", :as => "challenge_refuse"
  get "challenge_play" => "multiplayer_game#challenge_play", :as => "challenge_play"
  post "challenge_play" => "multiplayer_game#game_next", :as => "challenge_play"
  get "challenge_resume" => "multiplayer_game#challenge_resume", :as => "challenge_resume"
  get "challenge_withdraw" => "multiplayer_game#challenge_withdraw", :as => "challenge_withdraw"
  get "challenge_review" => "multiplayer_game#challenge_review", :as => "challenge_review"

  get "about" => "welcome#about", :as => "about"
  get "ranking" => "welcome#ranking", :as => "ranking"
  get "profile" => "welcome#profile", :as => "profile"
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
