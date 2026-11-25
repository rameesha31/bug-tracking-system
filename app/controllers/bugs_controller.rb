class BugsController < ApplicationController
  include Authentication
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:destroy]

  def index
    # if current_user.admin?
    #   @bugs = Bug.all
  
    # elsif current_user.reporter?
    #   @bugs = Bug.where(reported_by_id: current_user.id)
  
    # elsif current_user.developer?
    #   @bugs = Bug.where(assigned_to_id: current_user.id)
    # end
    @bugs = Bug.access_bugs(current_user)
  end

  def show
  end

  def new
    @projects = current_user.admin? ? Project.all : current_user.projects
    if params[:project_id].present?
      @project = @projects.find(params[:project_id])
      @bug = Bug.new(project_id: @project.id)
      @developers = @project.users.where(role: :developer)
    else
      @bug = Bug.new
      @developers = []
    end 
  end

  def create
    service = CreateBugService.new(current_user, bug_params)
    
    @bug = service.call
    @project = service.project
  
    if @bug.persisted?
      redirect_to bug_path(@bug), notice: "Bug created successfully!"
    else
      @projects = current_user.admin? ? Project.all : current_user.projects
      @developers = @project.users.where(role: :developer)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    service = UpdateBugService.new(@bug, current_user, bug_params)
    
    result = service.call
    
    if result == :unauthorized
      redirect_to bug_path(@bug) , alert: "You cannot update this bug"
    elsif result 
      redirect_to bug_path(@bug) , notice: "Bug updated successfully!"
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bug.destroy
    redirect_to bugs_path, notice: "Bug deleted successfully!"
  end

  def select_project
    @projects = current_user.admin? ? Project.all : current_user.projects
  
    @project = @projects.find(params[:project_id])
  
    @bug = Bug.new(project_id: @project.id)
  
    @developers = @project.users.where(role: :developer)
  
    render :new
  end

  private

  def set_bug
    # if current_user.admin?
    #   @bug = Bug.find(params[:id])
  
    # elsif current_user.reporter?
    #   @bug = Bug.find_by!(
    #     id: params[:id],
    #     reported_by_id: current_user.id
    #   )
  
    # elsif current_user.developer?
    #   @bug = Bug.find_by!(
    #     id: params[:id],
    #     assigned_to_id: current_user.id
    #   )
    @bug = Bug.access_bugs(current_user).find(params[:id])
  end
  def require_admin!
    unless current_user.admin?
      redirect_to bugs_path, alert: "Only admin can delete bugs."
    end
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :priority, :status, :assigned_to_id , :project_id, :acknowledged, images: []) 
  end
end
