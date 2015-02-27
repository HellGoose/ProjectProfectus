class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    
  end

  def vote
    topic = Topic.find(params[:id])
    if params[:dir] == 'up'
      topic.upvotes += 1
    elsif params[:dir] == 'down'
      topic.downvotes += 1
    end
    topic.save()
    render nothing: true
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @posts = @topic.posts
    @post = Post.new
  end

  # GET /projects/new
  def new
    @topic = Topic.new
    @forum = Forum.find(params[:forum])
  end

  # POST /projects
  # POST /projects.json
  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = session[:user_id]

    @forum = Forum.find(@topic.forum_id)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to forum.project }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :content, :forum_id, :image)
    end
end
