class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      flash[:notice] = 'You have been signed in'
      session[:user_id] = user.id
      redirect_to home_path
    else
      flash[:error] = "Invalid username or password"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "You are signed out"
  end
end
