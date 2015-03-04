class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    
  end

  def vote
    topic = Topic.find(params[:id])
    userVote = topic.votes.find_by(user_id: session[:user_id])
    if (userVote == nil)
      userVote = topic.votes.create(topic_id: topic.id, user_id: session[:user_id])
      if params[:dir] == 'up'
        topic.voteCount += 1
      elsif params[:dir] == 'down'
        topic.voteCount -= 1
      end        
    else
      if params[:dir] == 'up' and userVote.isDownvote != false
        userVote.isDownvote = false
        topic.voteCount += 2
      elsif params[:dir] == 'down' and userVote.isDownvote != true
        userVote.isDownvote = true
        topic.voteCount -= 2
      end
    end
    userVote.save
    topic.save()
    respond_to do |format|
      msg = { :status => "ok", :message => topic.voteCount }
      format.json  { render :json => msg }
    end
  end

  def edit
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @posts = @topic.posts.order('voteCount DESC')
    @post = Post.new
  end

  # GET /projects/new
  def new
    @topic = Topic.new
    @forum = Forum.find(params[:forum])
  end

  def update
    respond_to do |format|
      if isTopicOwner && @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    project = Project.find_by forum_id: @topic.forum_id
    respond_to do |format|
      if isTopicOwner && @topic.destroy
        format.html { redirect_to project, notice: 'Topic was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @topic, notice: 'You cannot delete this project.' }
        format.json { head :no_content }
      end
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = session[:user_id]

    @forum = Forum.find(@topic.forum_id)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @forum.project }
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

    def isTopicOwner
      @topic.user_id == session[:user_id]
    end
end
