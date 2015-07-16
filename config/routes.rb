Rails.application.routes.draw do
	# About page
	get 'about/index'

	# Login and Session
	get '/refer_a_friend', to: 'home#refer_a_friend'
	get '/signup/:referer', to: 'users#referer'
	get '/auth/:provider/callback', to: 'sessions#create'
	get '/auth/failure', to: redirect('/')
	get '/signout', to: 'sessions#destroy', as: 'signout'

	# Posts and comments
	get '/posts/answer/:campaign_id/:post_id', to: 'posts#answer'
	get '/campaigns/:id/posts/page/:page/:interval', to: 'posts#page'
	get '/posts/:id/comments/page/:page/:interval', to: 'posts#commentPage'

	# Campaign filtering
	get '/campaigns/page/:category/:searchText', to: 'campaigns#size'
	get '/campaigns/page/:category/:page/:interval/:sortBy/:searchText', to: 'campaigns#page', :as => :campaigns_page

	# Voting
	post '/vote/post/:id/:dir', to: 'posts#vote'
	get '/vote/campaign/:id/', to: 'campaigns#vote'

	# News
	get '/news/page/:page/:interval', to: 'news#page'
	get '/notifications', to: 'home#notifications'

	# Campaigns belonging to a user
	get '/users/:id/campaigns/:page/:interval', to: 'users#campaignPage'
	get '/campaigns/checkIfCanAdd/:title', to: 'campaigns#check_if_can_add'

	# Round administrating
	post '/admin/round/:type/:val', to: 'admin#round'

	# Pledge
	# get '/pledge', to: 'pledge#index'

	# Root
	root 'home#index'

	resources :pledge, only: [:index]
	resources :news
	resources :admin, only: [:index]
	resources :posts
	resources :campaigns
	resources :users, only: [:edit, :update, :show]

	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# You can have the root of your site routed with "root"
	# root 'welcome#index'

	# Example of regular route:
	#	 get 'products/:id' => 'catalog#view'

	# Example of named route that can be invoked with purchase_url(id: product.id)
	#	 get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

	# Example resource route (maps HTTP verbs to controller actions automatically):
	#	 resources :products

	# Example resource route with options:
	#	 resources :products do
	#		 member do
	#			 get 'short'
	#			 post 'toggle'
	#		 end
	#
	#		 collection do
	#			 get 'sold'
	#		 end
	#	 end

	# Example resource route with sub-resources:
	#	 resources :products do
	#		 resources :comments, :sales
	#		 resource :seller
	#	 end

	# Example resource route with more complex sub-resources:
	#	 resources :products do
	#		 resources :comments
	#		 resources :sales do
	#			 get 'recent', on: :collection
	#		 end
	#	 end

	# Example resource route with concerns:
	#	 concern :toggleable do
	#		 post 'toggle'
	#	 end
	#	 resources :posts, concerns: :toggleable
	#	 resources :photos, concerns: :toggleable

	# Example resource route within a namespace:
	#	 namespace :admin do
	#		 # Directs /admin/products/* to Admin::ProductsController
	#		 # (app/controllers/admin/products_controller.rb)
	#		 resources :products
	#	 end
end
