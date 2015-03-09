Rails.application.routes.draw do
  get 'about/index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  get '/projects/page/:category/:page/:interval', :to => 'projects#page', :as => :projects_page
  post '/projects/:id/vote', :to => 'projects#vote'

  get '/topics/:id/page/:page/:interval', :to => 'topics#page'

  post '/vote/project/:id/:dir', :to => 'project#vote'
  post '/vote/post/:id/:dir', :to => 'posts#vote'
  post '/vote/topic/:id/:dir', :to => 'topics#vote'

  get '/posts/answer/:topic_id/:post_id', :to => 'posts#answer'

  get '/admin/news', :to => 'admin#news'
  get '/admin/users', :to => 'admin#users'
  get '/admin/projects', :to => 'admin#projects'
  get '/admin/mods', :to => 'admin#mods'

    resources :sessions, only: [:create, :destroy]
    resources :projects
    resources :users
    resources :topics
    resources :posts
    resources :admin, only: [:index]
    resources :news
    resource :home, only: [:show]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

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
