Rails.application.routes.draw do
	# About page
	get 'about/index'

	# Login and Session
	get '/refer_a_friend', to: 'home#refer_a_friend'
	get '/signup/:referer', to: 'users#referer'
	get '/auth/:provider/callback', to: 'sessions#create'
	get '/auth/failure', to: redirect('/')
	get '/signout', to: 'sessions#destroy', as: 'signout'
	get '/users/current_user', to: 'users#current_user_info'
	get '/mobile/login', to: 'sessions#mobile_login'

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
	get '/refresh/campaigns/', to: 'campaigns#refresh_step'

	# News
	get '/news/page/:page/:interval', to: 'news#page'
	get '/notifications/:offset', to: 'home#notifications'

	# Campaigns
	get '/users/:id/campaigns/:page/:interval', to: 'users#campaignPage'
	get '/campaigns/checkIfCanAdd/:title', to: 'campaigns#check_if_can_add'
	get '/campaigns/log/:website', to: 'campaigns#log_unsupported_site', :website => /.*/
	get '/campaigns/:id/nominate', to: 'campaigns#nominate_campaign'

	# Abilities
	post '/campaigns/star/:id', to: 'ability#star'
	post '/campaigns/:campaign_id/report', to: 'ability#report'
	post '/ability/vote_again', to: 'ability#vote_again'

	# Admin
	post '/admin/round/:type/:val', to: 'admin#round'
	post '/admin/clear_all_nominations/', to: 'admin#clear_all_nominations'
	post '/admin/nominate_all', to: 'admin#nominate_all'
	post '/admin/reset_voting', to: 'admin#reset_voting'
	get '/admin/clear_campaign/:id', to: 'admin#clear_campaign'
	get '/admin/delete_campaign/:id', to: 'admin#delete_campaign'

	#Leaderboard
	get '/leaderboard/:page/:interval', to: 'users#page'

	#Bots
	post '/bot/message', to: 'bot#recive'

	# Pledge
	# get '/pledge', to: 'pledge#index'

	# Root
	root 'home#index'
	get 'landing', to: 'home#landing'

	resources :stat_dump, only: [:show]
	resources :pledge, only: [:index]
	resources :news
	resources :admin, only: [:index]
	resources :posts
	resources :campaigns
	resources :users, only: [:index, :edit, :update, :show]

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
