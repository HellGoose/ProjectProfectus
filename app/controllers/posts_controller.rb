class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    
  end

  def show
  end

  def commentPage
    comments = Post.find(params[:id]).comments.order("voteCount DESC")
    page = params[:page]
    interval = params[:interval]
    respond_to do |format|
      format.js { render partial: 'posts/comments', locals: { page: page, postsPerPage: interval, comments: comments } }
    end
  end

  def page
    @posts = Topic.find(params[:id]).posts.where("isComment = 0").order("voteCount DESC")
    page = params[:page]
    interval = params[:interval]
    respond_to do |format|
      format.js { render partial: 'posts', locals: { page: page, postsPerPage: interval } }
    end
  end

  def answer
    if current_user
      @post = Post.new
      @topic = Topic.find(params[:topic_id])
      @op = Post.find(params[:post_id])
      respond_to do |format|
        format.js { render partial: 'posts/postForm' }
      end
    end
  end

  def vote
    if current_user
      post = Post.find(params[:id])
      userVote = post.votes.find_by(user_id: session[:user_id])
      if (userVote == nil)
        userVote = post.votes.create(post_id: post.id, user_id: session[:user_id])
        if params[:dir] == 'up'
          post.voteCount += 1
        elsif params[:dir] == 'down'
          post.voteCount -= 1
        end        
      else
        if params[:dir] == 'up' and userVote.isDownvote != false
          userVote.isDownvote = false
          post.voteCount += 2
        elsif params[:dir] == 'down' and userVote.isDownvote != true
          userVote.isDownvote = true
          post.voteCount -= 2
        end
      end
      userVote.save()
      post.save()
      respond_to do |format|
        msg = { :status => "ok", :message => post.voteCount }
        format.json  { render :json => msg }
      end
    end
  end

  # GET /projects/new
  def new
    if current_user
      @post = Post.new
      @op = nil
    end
  end

  def edit
    if !isPostOwner && !isAdmin
      redirect_to Topic.find(@post.topic_id)
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    if current_user
      @post = Post.new(content: post_params[:content], topic_id: post_params[:topic_id])
      @post.user_id = session[:user_id]
      @topic = Topic.find(@post.topic_id)

      if (post_params[:post_id] != nil)
        @op = Post.find(post_params[:post_id])
        @op.comments << @post
        @op.save
        @post.isComment = true
      end

      respond_to do |format|
        if @post.save
          @topic.save
          format.html { redirect_to @topic }
        else
          format.html { redirect_to @topic }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    topic = Topic.find(@post.topic_id)
    respond_to do |format|
      if (isPostOwner || isAdmin) && @post.update(post_params)
        format.html { redirect_to topic, notice: 'Post was successfully updated.' }
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
    topic = Topic.find(@post.topic_id)
    respond_to do |format|
      if isPostOwner && @post.destroy
        format.html { redirect_to topic, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to topic, notice: 'You cannot delete this post.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :topic_id, :post_id)
    end

    def isPostOwner
      @post.user_id == session[:user_id]
    end
end