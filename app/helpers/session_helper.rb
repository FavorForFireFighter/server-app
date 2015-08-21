module SessionHelper
  def let_login
    if current_user.nil?
      redirect_to(session_index_path, {alert: t('controller.common.not_login')})
    end
  end

  def is_admin?
    current_user.admin_flag
  end
end
