class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    
  end

  def up
    forum = Forum.find(params[:forum])
    topic = forum.topics.find(params[:topic])
    topic.upvotes += 1
    topic.save
    render nothing: true
  end

  def down
    forum = Forum.find(params[:forum])
    topic = forum.topics.find(params[:topic])
    topic.downvotes += 1
    topic.save
    render nothing: true
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
    @posts = @topic.posts
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
    def set_topic
      @topic = Forum.find(params[:forum]).topics.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title)
    end
end