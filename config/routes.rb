MaasiveWeb::Application.routes.draw do

  devise_for :developers, :controllers => { :registrations => "developers" }
  #devise_for :apps

  resources :invite_requests

  namespace "admin" do
    resource  :dashboard
    resources :invite_requests do
      member do
        get :invite
      end
    end
    resources :developers do
      collection do
        get  :import
        post :import
      end
      member do
        get :hijack
      end
    end
    resource  :statistics
    resource  :mongo
    resources :services
    resources :apps
    resources :documentation
    resources :service_documentation
  end

  resources :welcome
  resources :accounts do
    resources :memberships
    resources :services, :controller => "Account::Services"
  end

  resources :documentation do
    post :search, :on => :collection
  end

  resource :dashboard

  resources :apps do
    member do
      get :authenticate
      get :secret_key
    end
    resources :versions
    resources :api_tables do
      member do
        delete :destroy_all
      end
    end
    resource  :statistics
    resources :services do
      resource :service_connections do
        member do
          post :run
        end
      end
    end
  end

  # 
  match 'what_is_maasive' => 'dashboards#what_is_maasive'
  match 'about' => 'dashboards#about'

  # maasive web services system routes
  match 'producers' => 'producers#index', :via => "get"

  match 'installers' => 'documentation#installers'
  
  resources :services do
    member do
      get  :add
      post :add
    end
  end
  #match 'services' =>  'services#index', :via => "get"
  #match 'services/:title' => 'services#show'

  # maasive web email service example
  match 'maasiveweb/email', :via => "get"


  # API TABLE CREATE
  match 'apps/:app_id/versions/:version_hash'                 => 'versions#create',   :via => "post"

  # ENDPOINT ROUTES
  match 'apps/:app_id/versions/:version_hash/:name'           => 'endpoint#index',   :via => "get"
  match 'apps/:app_id/versions/:version_hash/:name/count'     => 'endpoint#count',   :via => "get"
  match 'apps/:app_id/versions/:version_hash/:name'           => 'endpoint#create',  :via => "post"
  match 'apps/:app_id/versions/:version_hash/:name/new'       => 'endpoint#new',     :via => "get"
  match 'apps/:app_id/versions/:version_hash/:name/:id'       => 'endpoint#show',    :via => "get"
  match 'apps/:app_id/versions/:version_hash/:name/:id/edit'  => 'endpoint#edit',    :via => "get"
  match 'apps/:app_id/versions/:version_hash/:name/edit'      => 'endpoint#new',     :via => "get"
  match 'apps/:app_id/versions/:version_hash/:name/:id'       => 'endpoint#update',  :via => "put"
  match 'apps/:app_id/versions/:version_hash/:name/:id'       => 'endpoint#delete',  :via => "delete"


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
  match 'nda' => 'welcome#nda'

  root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
