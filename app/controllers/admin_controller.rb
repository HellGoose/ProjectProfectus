class AdminController < ApplicationController

  def index
    @newsInterval = 5
    @all_news = News.order("created_at DESC")
    @news = News.new
    #@flagged = Project.all.where('flagged > 0')
    if !isAdmin
      redirect_to '/'
    end
  end

  def round
    round = Round.first
  	if params[:duration] == 'start'
  		respond_to do |format|
          msg = { :status => 'ok', :message => 'Duration updated to' + round.duration }
          format.json  { render :json => msg }
    	end
  	end
  end
end