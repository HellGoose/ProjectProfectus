Rails.application.routes.draw do
  get 'about/index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  get '/projects/page/:category/:page/:interval', :to => 'projects#page', :as => :projects_page
  post '/projects/:id/vote', :to => 'projects#vote'
  post '/projects/:id/flag/:type', :to => 'projects#flag'
  post '/projects/:id/donate/:amount', :to => 'projects#donate'

  get '/topics/:id/page/:page/:interval', :to => 'topics#page'

  post '/vote/post/:id/:dir', :to => 'posts#vote'
  post '/vote/topic/:id/:dir', :to => 'topics#vote'

  post '/donate/:amount', :to => 'home#donate'

  get '/posts/answer/:topic_id/:post_id', :to => 'posts#answer'

  get '/admin/news', :to => 'admin#news'
  get '/admin/users', :to => 'admin#users'
  get '/admin/projects', :to => 'admin#projects'
  get '/admin/mods', :to => 'admin#mods'

  post '/users/:id/addMoney/:amount', :to => 'users#addMoney'

  get '/news/page/:page/:interval', :to => 'news#page'

    resources :sessions, only: [:create, :destroy]
    resources :projects
    resources :users, only: [:edit, :update, :show]
    resources :topics
    resources :posts
    resources :home, only: [:show, :donate]
    resources :admin, only: [:index]
    resources :news

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
