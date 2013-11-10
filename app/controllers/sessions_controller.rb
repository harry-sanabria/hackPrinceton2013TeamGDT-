class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to current_user
    end
  end

  def create
    user = User.authenticate(env["omniauth.auth"])
    if user
      current_user = user
      session[:user_id] = user.id
      redirect_to current_user
    else
      flash.now.alert = "Invalid login"
      render "new"
    end
  end

  # Logs users out and clears current_user variable
  def destroy
    session[:user_id] = nil
    current_user = nil
    redirect_to root_url, :notice => "Logged out!"
  end

  def logged_in
    redirect_to current_user, :notice => "Logged in with facebook"
  end

end
