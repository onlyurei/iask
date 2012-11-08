ActionController::Routing::Routes.draw do |map|
  map.resources :notes

  map.resources :keywords, :collection => {:list_entries => :get}

  map.resources :queries, :collection => {:solved => :get, 
                                          :unsolved => :get}

  map.resources :entries, :member => {:list_keywords => :get,
                                      :list_relevances => :get,
                                      :update_keyword => :put,
                                      :create_keyword => :post,
                                      :destroy_relevance => :delete}

  map.resources :courses, :member => {:list_entries => :get,
                                      :list_queries => :get,
                                      :list_teachers => :get,
                                      :list_students => :get,
                                      :list_keywords => :get,
                                      :create_entry => :post,
                                      :create_query => :post,
                                      :create_queries => :post,
                                      :add_user => :put,
                                      :delete_user => :put},
                          :collection => {:list_all => :get}
                          
  map.resources :users, :collection => {:students => :get, :teachers => :get,
                                        :destroy_by_official_id => :delete},
                        :member => {:list_courses => :get, 
                                    :update_password => :put,
                                    :add_course => :put}

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

 
  map.resource :session
  
  map.signup '/signup', :controller => 'users',
  :action => 'new'
  map.login '/login', :controller => 'sessions',
  :action => 'new'
  map.logout '/logout', :controller => 'sessions',
  :action => 'destroy'

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
