class PostsController < ApplicationController
  before_action :set_posts, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  def vote
    post = Post.find(params[:id])
    print params[:dir]
    if params[:dir] == 'up'
      post.upvotes += 1
    elsif params[:dir] == 'down'
      post.downvotes += 1
    end
    post.save()
    render nothing: true
  end

  # GET /projects/new
  def new
    @post = Post.new
  end

  def edit
    if !isPostOwner
      redirect_to @post
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @post = Post.new(post_params)
    @post.user_id = session[:user_id]
    @topic = Topic.find(@post.topic_id)

    respond_to do |format|
      if @post.save
        @topic.postCount += 1
        @topic.save
        format.html { redirect_to @topic }
      else
        format.html { redirect_to @topic }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if isPostOwner && @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Post was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_posts
      @posts = Project.find(params[:id]).forum.topics.posts
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :topic_id)
    end

    def isPostOwner
      @post.user_id == session[:user_id]
    end
end
