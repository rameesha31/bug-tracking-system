class DashboardController < ApplicationController
  include Authentication

  def index
    # if current_user.admin?
    #   @projects = Project.all
    # else
    #   @projects = current_user.projects
    # end

    @projects = Project.access_project(current_user)

    # if current_user.admin?
    #   @bugs = Bug.all
    # else
    #   @bugs = Bug.where(project_id: @projects.select(:id))
    # end

    @bugs = Bug.dashboard_bugs(current_user)

    if params[:q].present?
      @bugs = @bugs.search(params[:q])
    end

    # Filter by project
    if params[:project_id].present?
      project = @projects.find_by(id: params[:project_id])
      @bugs = project ? @bugs.where(project_id: project.id) : @bugs.none
    end

    # Filter by status
    if Bug.statuses.key?(params[:status])
      @bugs = @bugs.where(status: params[:status])
    end

    # Filter by priority
    if Bug.priorities.key?(params[:priority])
      @bugs = @bugs.where(priority: params[:priority])
    end

    # Sort bugs
    case params[:sort]
    when "oldest"
      @bugs = @bugs.order(created_at: :asc)
    when "title"
      @bugs = @bugs.order(title: :asc)
    else
      @bugs = @bugs.order(created_at: :desc)
    end

    # Dashboard counts
    @total_projects = @projects.count
    @total_bugs = @bugs.count
    @new_bugs = @bugs.where(status: :new_bug).count
    @in_progress_bugs = @bugs.where(status: :in_progress).count
    @resolved_bugs = @bugs.where(status: :resolved).count

    if current_user.developer?
      @assigned_bugs = @bugs.where(assigned_to_id: current_user.id)
    elsif current_user.reporter?
      @assigned_bugs = @bugs.where(reported_by_id: current_user.id)
    else
      @assigned_bugs = @bugs
    end
  end
end
