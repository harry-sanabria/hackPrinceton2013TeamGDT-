class UsersController < ApplicationController
  def show
    if !(current_user.id.to_s == params[:id])
      flash[:notice] = "You do not have permission to view this page!"
      redirect_to current_user
      return
    else
      @user = current_user
    end
  end

end
