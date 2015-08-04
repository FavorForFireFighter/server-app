class UsersController < ApplicationController
  include SessionHelper

  before_action :let_login, except: [:new, :create]
  before_action :check_user, except: [:new, :create]

  def show
    @user = current_user
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
    @user = current_user
  end

  def update
    _params = edit_params
    user = current_user
    unless user.authenticate(params[:current_password])
      @user = user
      flash.now[:error] = t('controller.users.login_error')
      render :edit
      return
    end

    user.attributes = _params
    unless user.save
      @user = user
      render :edit
      return
    end

    redirect_to user_path(user.id),{notice: t('controller.common.updated')}
  end

  def photos
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def edit_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def check_user
    if current_user.id != params[:id].to_i
      render 'common/access_denied'
      return
    end
  end
end
