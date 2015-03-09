class AdminController < ApplicationController
  before_action :set_news, only: [:index, :news]

  def index
  end

  def news
  	respond_to do |format|
      format.js { render partial: 'news/news' }
    end
  end

  def users
  	respond_to do |format|
      format.js { render partial: 'flagged_users' }
    end
  end

  def projects
  	respond_to do |format|
      format.js { render partial: 'flagged_projects' }
    end
  end

  def mods
  	respond_to do |format|
      format.js { render partial: 'mods' }
    end
  end

  private
  	def set_news
  		@news = News.new
  		@all_news = News.all
  	end
end