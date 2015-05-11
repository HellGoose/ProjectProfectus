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
          msg = { status: 'ok', message: '<span class="alert alert-success">Duration updated to ' + view_context.distance_of_time_in_words(round.duration) +'</span>'}
          format.json  { render json: msg }
    	end
    elsif params[:type] == 'force'
      round.forceNewRound = true
      respond_to do |format|
          msg = { status: 'ok', message: '<span class="alert alert-success">Forcing new round!</span>' }
          format.json  { render json: msg }
      end
    elsif params[:type] == 'error'
      respond_to do |format|
          msg = { status: 'ok', message: '<span class="alert alert-warning">Invalid input. Only positive numbers.</span>' }
          format.json  { render json: msg }
      end
    end
    round.save
  end
end