class PostsController < ApplicationController
  before_action :set_posts, only: [:show, :edit, :update, :destroy]

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

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
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
    def incrementUpVotes
      @post.topicCount += 1
      @post.save
    end

    def incrementDownVotes
      @post.postCount += 1
      @post.save
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_posts
      @posts = Project.find(params[:id]).forum.topics.posts
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content)
    end

    def isPostOwner
      @post.user_id == session[:user_id]
    end
end
