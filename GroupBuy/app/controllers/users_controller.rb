class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		redirect_to root_url, :notice => "Signed up! Please log in to make purchases!"
  	else
  		render "new"
  	end
  end

  def show
    if !(current_user.id.to_s == params[:id])
      flash[:notice] = "You do not have permissioin to view this page!"
      redirect_to current_user
      return
    end
  end

end
