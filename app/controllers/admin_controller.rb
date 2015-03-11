class AdminController < ApplicationController
  before_action :set_news, only: [:index, :news]

  def index
    if !isAdmin
      redirect_to '/'
    end
  end

  def news
  	respond_to do |format|
      if isAdmin
        format.js { render partial: 'news/news' }
      end
    end
  end

  def users
  	respond_to do |format|
      if isAdmin
        format.js { render partial: 'flagged_users' }
      end
    end
  end

  def projects
    @flagged = Project.all.where('flagged > 0')
  	respond_to do |format|
      if isAdmin
        format.js { render partial: 'flagged_projects' }
      end
    end
  end

  def mods
  	respond_to do |format|
      if isAdmin
        format.js { render partial: 'mods' }
      end
    end
  end

  private
  	def set_news
  		@news = News.new
  		@all_news = News.order("created_at DESC")
  	end
end