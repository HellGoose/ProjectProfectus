class ForumsController < ApplicationController
  before_action :set_forum, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    
  end

  def page
    id = params[:id]
    @topics = Forum.find(id).topics.order('voteCount DESC')
    page = params[:page]
    interval = params[:interval]
    respond_to do |format|
      format.js { render partial: 'forum', locals: { id: id, page: page, topicsPerPage: interval } }
    end
  end

  def updateTopicCount
    incrementTopicCount
  end

  def updatePostCount
    incrementPostCount
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @forum = Forum.new
  end

  # POST /projects
  # POST /projects.json
  def create
    @forum = Forum.new
  end

  private
    def incrementTopicCount
      @forum.topicCount += 1
      @forum.save
    end

    def incrementPostCount
      @forum.postCount += 1
      @forum.save
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_forum
      @forum = Project.find(params[:id]).forum
    end
end
