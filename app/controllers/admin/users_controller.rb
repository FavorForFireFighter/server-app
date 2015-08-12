class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.all.order(:id)
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    user = User.find_by(id: params[:id])
    user.attributes = edit_params
    unless user.save
      @user = user
      render :edit
      return
    end

    redirect_to({action: 'show', id: user.id}, {notice: t('controller.common.updated')})
  end

  def destroy
    user = User.find_by(id: params[:id])
    unless user.destroy
      redirect_to({action: 'index', id: user.id}, {alert: t('controller.admin.cant_delete')})
    end
    if user.id == current_user.id
      redirect_to session_logout_path
    else
      redirect_to({action: 'index'}, {notice: t('controller.admin.delete')})
    end
  end

  def photos_index
    @bus_stop_photos = BusStopPhoto.where(user_id: params[:id]).order(:id).includes(:bus_stop).references(:bus_stop)
  end

  private
  def edit_params
    params.require(:user).permit(:email, :admin_flag, :password, :password_confirmation)
  end
end
