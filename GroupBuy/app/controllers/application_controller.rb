class ApplicationController < ActionController::Base
  # Troll SSL bypass that makes everything super vulnerable (I think)
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  helper_method :current_user
  # Sets the current_user variable
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  
  helper_method :dollars
  # Formats given string to %.02f
  def dollars(str)
    "$%.2f" % str
  end

  # Checks to see if a user has logged in, if not, restrict access by redirecting
  # to homepage and give a notification
  def login_required
    redirect_to('/') if current_user.blank?
    flash[:notice] = "Please log in first, or create an account!" if current_user.blank?
  end
  
  # Checks to see if a user has attached a Venmo account, if not, restrict access by
  # redirecting to homepage and give a notification
  def venmo_required
    if current_user.venmo.blank?
      redirect_to request.referer,
          :notice => "Oops! There is not yet a Venmo account associated with this user."
    end
  end
end
