class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_user
    if !logged_in?
      flash[:error] = "Please sign in to access"
      redirect_to sing_in_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  helper_method :logged_in?, :current_user
end
