class UsersController < ApplicationController
  def show
  end

  def new
    @user = User.new
  end

  def create
    user = User.new user_params
    if user.save
      reset_session
      session[:id] = user.id
      redirect_to user
    else
      @user = user
      render :new
    end
  end

  def edit
  end

  def update
    redirect_to root_path
  end

  def photos
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
