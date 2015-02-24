class TopicsController < ApplicationController
  before_action :set_topics, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    
  end

  def updateUpVotes
    incrementUpVotes
  end

  def updateDownVotes
    incrementDownVotes
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @topic = Topic.new
  end

  # POST /projects
  # POST /projects.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def incrementUpVotes
      @topic.topicCount += 1
      @topic.save
    end

    def incrementDownVotes
      @topic.postCount += 1
      @topic.save
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_topics
      @topics = Project.find(params[:id]).forum.topics
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title)
    end
end
