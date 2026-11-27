class UpdateBugService
    attr_reader :bug
  
    def initialize(bug, user, params)
      @bug = bug
      @user = user
      @params = params
    end
  
    def call
      if @user.admin?
        @bug.update(@params)
  
      elsif @user.developer?
        @bug.update(
          status: @params[:status],
          acknowledged: @params[:acknowledged]
        )
  
      elsif @user.reporter?
        if @params[:priority].present?
          @bug.update(priority: @params[:priority])
        elsif @bug.status_resolved? && @params[:status] == "closed"
          @bug.update(status: @params[:status])
        else
          :unauthorized
        end
      end
    end
  end