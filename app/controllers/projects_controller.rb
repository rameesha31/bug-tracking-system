class ProjectsController < ApplicationController
  include Authentication
  before_action :require_admin!, only: [:new ,:create ,:edit ,:update ,:destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]


  def index
    # if current_user.admin?
    #   @projects = Project.all
    # else
    #   @projects = current_user.projects
    # end
    @projects = Project.access_project(current_user)
  end

  def show
    @users = @project.users
    @visible_bugs = @project.bugs.access_bugs(current_user)
  end

  def new
    @project = Project.new
    @users = User.project_members
  end

  def create
    @project = Project.new(project_params)
  
    if @project.save
      @project.users = User.where(id: params[:user_ids], role: [:developer, :reporter])
  
      redirect_to @project, notice: "Project created successfully!"
    else
      @users = User.project_members
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @users = User.project_members
  end

  def update
    if @project.update(project_params)
      @project.users = User.where( id: params[:user_ids], role: [:developer, :reporter]) if params[:user_ids].present?
  
      redirect_to @project, notice: "Project updated successfully!"
    else
      @users = User.project_members
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project deleted successfully!"
  end

  private

  def set_project
    # if current_user.admin?
    #   @project = Project.find(params[:id])
    # else
    #   @project = current_user.projects.find(params[:id])
    # end
    @project = Project.access_project(current_user).find(params[:id])

  end

  def require_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "Only admin can perform this action."
    end
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end