UpdateKitCom::Application.routes.draw do
  devise_for :users

  resources :ios_applications
  
  
  match 'ios_applications/bundle_identifier/:bundle_identifier/update_info' => 'ios_applications#update_info', :bundle_identifier => /[a-z].+/i
  match 'ios_applications/bundle_identifier/:bundle_identifier/redirect_to_product_page' => 'ios_applications#redirect_to_product_page', :bundle_identifier => /[a-z].+/i

  match 'ios_applications/bundle_identifier/:bundle_identifier' => 'ios_applications#show', :bundle_identifier => /[a-z].+/i, :as => "ios_application_register_bundle_identifier"

  match 'ios_applications/:id/fetch_version_number' => "ios_applications#fetch_version_number", :as => "ios_application_fetch_version_number"
  match 'ios_applications/:id/protect' => "ios_applications#protect_application", :as => "ios_application_protect_application"
  match 'ios_applications/:id/unprotect' => "ios_applications#unprotect_application", :as => "ios_application_unprotect_application"
  
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
  root :to => 'ios_applications#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
