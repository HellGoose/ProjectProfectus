class ProjectsController < ApplicationController
  before_action :set_project, only: [:vote, :show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all.order('voteCount DESC')
    @projectsInterval = 8
  end

  def page
  	if params[:category].to_i > 0
	  	category = Category.find(params[:category])
	    @projects = category.projects.order('voteCount DESC')
    else
		  @projects = Project.all.order('voteCount DESC')
	  end

    page = params[:page]
    interval = params[:interval]
    respond_to do |format|
      format.js { render partial: 'projectList', locals: { page: page, projectsPerPage: interval } }
    end
  end

  def vote
    if (@project.votes.find_by(user_id: session[:user_id]) == nil)
      vote_project
    else
      removeVote
    end
    render nothing: true
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @topics = @project.forum.topics
    @topics = @topics.order('voteCount DESC')
    @topicsInterval = 5
  end

  # GET /projects/new
  def new
   	@project = Project.new
  end

  # GET /projects/1/edit
  def edit
    if !isProjectOwner
      redirect_to @project
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = session[:user_id]
    forum = Forum.create
    @project.forum_id = forum.id

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if isProjectOwner && @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def vote_project
	    @project.voteCount += 1
	    @project.votes.create(project_id: @project.id, user_id: session[:user_id])
	    @project.save
    end

    def removeVote
      @project.votes.find_by(user_id: session[:user_id]).delete
      @project.voteCount -= 1
      @project.save
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit( :title, :description, :content, :tags, :logoLink,
                    :voteCount, :finalVoteCount, :flagged, :isGettingFunded, :category_id)
    end

    def isProjectOwner
      @project.user_id == session[:user_id]
    end
end
