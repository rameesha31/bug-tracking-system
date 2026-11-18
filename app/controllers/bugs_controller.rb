class BugsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:destroy]

  def index
    if current_user.admin?
      @bugs = Bug.all
  
    elsif current_user.reporter?
      @bugs = Bug.where(reported_by_id: current_user.id)
  
    elsif current_user.developer?
      @bugs = Bug.where(assigned_to_id: current_user.id)
    end
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
    @project = if current_user.admin?
      Project.find(params[:bug][:project_id])
    else
      current_user.projects.find(params[:bug][:project_id])
    end
  
    @bug = @project.bugs.new(bug_params)
    @bug.reporter = current_user
  
    developer = @project.users.find_by(
      id: params[:bug][:assigned_to_id],
      role: :developer
    )
  
    unless developer
      @bug.errors.add(:assigned_to_id, "is not a developer in this project")
    end
  
    if @bug.errors.empty? && @bug.save
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
    if current_user.admin?
  
      if @bug.update(bug_params)
        redirect_to bug_path(@bug), notice: "Bug updated successfully!"
      else
        render :edit, status: :unprocessable_entity
      end
  
    elsif current_user.developer?
  
      if @bug.update(status: params[:bug][:status])
        redirect_to bug_path(@bug), notice: "Bug status updated!"
      else
        render :edit, status: :unprocessable_entity
      end
  
    elsif current_user.reporter?
  
      if @bug.status_resolved? &&
          ["closed", "new_bug"].include?(params[:bug][:status])
  
        if @bug.update(status: params[:bug][:status])
          redirect_to bug_path(@bug), notice: "Bug review completed!"
        else
          render :edit, status: :unprocessable_entity
        end
  
      else
        redirect_to bug_path(@bug), alert: "You cannot update this bug."
      end
  
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
    if current_user.admin?
      @bug = Bug.find(params[:id])
  
    elsif current_user.reporter?
      @bug = Bug.find_by!(
        id: params[:id],
        reported_by_id: current_user.id
      )
  
    elsif current_user.developer?
      @bug = Bug.find_by!(
        id: params[:id],
        assigned_to_id: current_user.id
      )
    end
  end
  def require_admin!
    unless current_user.admin?
      redirect_to bugs_path, alert: "Only admin can delete bugs."
    end
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :priority, :status, :assigned_to_id)
  end
end
