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

  def iteration
  	if params[:run] == 'start'
  		system( "ruby 'iteration.rb'" )
  		respond_to do |format|
        	msg = { :status => 'ok', :message => 'Script is running' }
			format.json  { render :json => msg }
    	end
  	end
  end
end