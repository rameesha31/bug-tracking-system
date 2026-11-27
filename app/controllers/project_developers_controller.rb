class ProjectDevelopersController < ApplicationController
  def index
    projects = current_user.admin? ? Project.all : current_user.projects
    @project = projects.find(params[:project_id])

    developers = @project.users.where(role: :developer)

    render json: developers.select(:id, :name)
  end
end