class ForumsController < ApplicationController
  before_action :set_forum, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    
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
