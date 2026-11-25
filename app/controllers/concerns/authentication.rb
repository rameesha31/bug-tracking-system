module Authentication
    extend ActiveSupport::Concern
    
    included do
        before_action :authenticate_user!
    end 
    private 
    
    def authenticate_user!
        unless logged_in?
            redirect_to login_path, alert: "Please login first"
        end
    end
end 