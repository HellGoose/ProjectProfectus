class NewsController < ApplicationController
	before_action :set_news, only: [:edit, :update, :destroy]

	# Public: Creates a new news.
	# Route: POST root/news/
	#
	# @news - The news to be added in the database.
	#
	# Renders admin#index iff creation succeeds, otherwise renders news#new.
	def create
		@news = News.new(news_params)

		respond_to do |format|
			if isAdmin && @news.save
				format.html { redirect_to "/admin/" }
			else
				format.html { render :new }
				format.json { render json: @news.errors, status: :unprocessable_entity }
			end
		end
	end

	# Public: Prepares variables for the current page.
	# Route: root/news/page/:page/:interval
	# 	:page 			- The current page.
	# 	:interval 	- news per page.
	#
	# @allNews - All news present in the database.
	# page 		 - The page to switch to.
	# interval - Number of news shown per page.
	#
	# Renders the news on the page to switch to.
	def page
		@allNews = News.order("created_at DESC")
		page = params[:page]
		interval = params[:interval]
		respond_to do |format|
			format.js { render partial: "news", locals: { page: page, newsPerPage: interval } }
		end
	end

	# Public: Prepares variables for news#edit.
	# Route: GET root/news/:id/edit
	# 	:id - The id of the news in the database.
	#
	# Renders news#edit.
	def edit
	end

	# Public: Updates a news iff the current user is an admin.
	# Route: PUT root/news/:id
	# 	:id - The id of the news in the database.
	#
	# Renders admin#index iff the update succeeds, else rerenders news#edit with the error.
	def update
			respond_to do |format|
			if isAdmin && @news.update(news_params)
				msg = "<span class=\"alert alert-success\">News was successfully updated.</span>"
				format.html { redirect_to "/admin/", notice: msg }
				format.json { render :show, status: :ok, location: @news }
			else
				format.html { render :edit }
				format.json { render json: @news.errors, status: :unprocessable_entity }
			end
		end
	end

	# Public: Deletes a news from the database.
	# Route: DELETE root/news/:id
	# 	:id - The id of the news in the database.
	#
	# Renders admin#index iff the user is an admin, else renders root.
	def destroy
		respond_to do |format|
			if !isAdmin
				format.html { redirect_to "/" }
			elsif @news.destroy
				msg = "<span class=\"alert alert-success\">News was successfully destroyed.</span>"
				format.html { redirect_to "/admin/", notice: msg }
				format.json { head :no_content }
			else
				msg = "<span class=\"alert alert-warning\">Could not destroy the news.</span>"
				format.html { redirect_to "/admin/", notice: msg }
				format.json { head :no_content }
			end
		end
	end

	private

	# Private: Checks if the fields of the given parameters are allowed.
	#
	# params - The parameters to check.
	#
	# Returns the parameters iff the parameters are allowed.
	def news_params
		params.require(:news).permit(:title, :content, :sticky)
	end

	# Private: Makes the a news globally accessible.
	#
	# @news - The globally accessible news.
	#
	# Returns the news.
	def set_news
		@news = News.find(params[:id])
	end
end
