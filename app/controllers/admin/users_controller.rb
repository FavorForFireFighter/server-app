class Admin::UsersController < Admin::ApplicationController
  def index
    if request.xhr?
      session[:admin_user_list_page] = params[:page]
      users = User.not_deleted.order(:id).page(params[:page])
      paginator = view_context.create_pager_with_entries(users, nil, true)
      list = render_to_string partial: 'user_list', locals: {users: users}
      render json: {paginator: paginator, list: list}
      return
    end
    if request.referer.present? && request.referer.include?("/admin/users") && !request.referer.include?("/admin/users/index")
      @users = User.not_deleted.order(:id).page(session[:admin_user_list_page])
    else
      session[:admin_user_list_page] = nil
      @users = User.not_deleted.order(:id).page(params[:page])
    end
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
    unless user.soft_delete
      redirect_to({action: 'index', id: user.id}, {alert: t('controller.admin.cant_delete')})
    end
    if user.id == current_user.id
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      redirect_to(new_user_session_path, {notice: t('controller.admin.delete')})
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
