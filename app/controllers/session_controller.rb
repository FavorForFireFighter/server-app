class SessionController < ApplicationController
  include SessionHelper

  def index
    @user = User.new
  end

  def login
    user = User.find_by(username: params[:user][:username])
    logger.debug user.inspect
    if user && user.authenticate(params[:user][:password])
      reset_session
      current_user = user
      session[:id] = user.id
      redirect_to root_path
    else
      flash.now[:error] = t('controller.session.login_error')
      @user = User.new login_params
      render :index
    end
  end

  def logout
    reset_session
    redirect_to root_path, {notice: t('controller.common.logout')}
  end

  private
  def login_params
    params.require(:user).permit(:username, :password)
  end
end
