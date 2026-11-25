class UpdateBugService
    attr_reader :bug

    def initialize(bug,user,params)
        @bug = bug
        @user = user 
        @params = params 
    end 

    def call 
        if @user.admin?
            @bug.update(@params)
        elsif @user.developer?
            @bug.update(status: @params[:status], acknowledged: @params[:acknowledged])
        elsif @user.reporter?
            if @bug.status_resolved? && ["closed"].include?(@params[:status])
                @bug.update(status: @params[:status])
            else
                :unauthorized 
            end 
        end
    end 
end