module SessionHelper
  def current_user
    @_current_user ||= User.find_by(id: session[:id])
  end

  def current_user=(user)
    @_current_user = user
  end

  def let_login
    if current_user.nil?
      redirect_to(session_index_path, {alert: t('controller.common.not_login')})
    end
  end

  def signed_in?
    current_user.present?
  end

end
