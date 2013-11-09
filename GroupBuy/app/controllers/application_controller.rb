class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  # Sets the current_user variable
  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # Checks to see if a user has logged in, if not, restrict access by redirecting
  # to homepage and give a notification
  def login_required
    redirect_to('/') if current_user.blank?
    flash[:notice] = "Please log in first, or create an account!" if current_user.blank?
  end
end
