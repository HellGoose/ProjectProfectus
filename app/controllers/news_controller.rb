class NewsController < ApplicationController

	def create
		@news = News.new(news_params)

		respond_to do |format|
			if @news.save
				format.html { redirect_to '/admin' }
			else
				format.html { render :new }
				format.json { render json: @news.errors, status: :unprocessable_entity }
			end
		end
	end

	def show
	end

	private
		def news_params
			params.require(:news).permit(:title, :content)
		end
end
