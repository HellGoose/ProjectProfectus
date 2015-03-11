class NewsController < ApplicationController
	before_action :set_news, only: [:show, :edit, :update, :destroy]

	def create
		@news = News.new(news_params)

		respond_to do |format|
			if isAdmin && @news.save
				format.html { redirect_to '/admin/' }
			else
				format.html { render :new }
				format.json { render json: @news.errors, status: :unprocessable_entity }
			end
		end
	end

	def index
		@all_news = News.order("created_at DESC")
	end

	def show
	end

	def edit
	end

	def update
	    respond_to do |format|
			if isAdmin && @news.update(news_params)
				format.html { redirect_to '/admin/', notice: 'News was successfully updated.' }
				format.json { render :show, status: :ok, location: @news }
			else
				format.html { render :edit }
				format.json { render json: @news.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		respond_to do |format|
			if isAdmin && @news.destroy
				format.html { redirect_to '/admin/', notice: 'News was successfully destroyed.' }
				format.json { head :no_content }
			else
				format.html { redirect_to '/' }
			end
		end
    end

	private
		def news_params
			params.require(:news).permit(:title, :content, :sticky)
		end

		def set_news
			@news = News.find(params[:id])
		end
end
