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
    round = Round.lock.first
  	if params[:type] == 'update'
      round.duration = params[:val].to_i
  		respond_to do |format|
          msg = { :status => 'ok', :message => 'Duration updated to' + round.duration.to_s}
          format.json  { render :json => msg }
    	end
    elsif params[:type] == 'force'
      round.forceNewRound = true
      respond_to do |format|
          msg = { :status => 'ok', :message => 'Forcing new round!' }
          format.json  { render :json => msg }
      end
    end
    round.save
  end
end