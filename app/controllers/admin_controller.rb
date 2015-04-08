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
end