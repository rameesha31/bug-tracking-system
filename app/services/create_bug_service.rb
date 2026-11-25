class CreateBugService 
    attr_reader :project 
    
    def initialize(user,params)
        @user = user 
        @params = params
    end

    def call 
        @project = if @user.admin? 
            Project.find(@params[:project_id])
        else 
            @user.projects.find(@params[:project_id])
        end 

        bug = @project.bugs.new(@params.except(:project_id))
        bug.reporter = @user 

        developer = @project.users.find_by( 
            id: @params[:assigned_to_id],
            role: :developer
        )
        unless developer 
            bug.errors.add(:assigned_to_id, "is not a developer in this project")
        end 
        Rails.logger.info("CREATE IMAGES: #{@params[:images].inspect}")
        bug.save if bug.errors.empty?
        
        bug 
    end

end