class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_path
    end 
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Login successful!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out successfully!"
  end
end
