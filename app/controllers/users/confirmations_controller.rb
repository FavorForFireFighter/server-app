class Users::ConfirmationsController < Devise::ConfirmationsController

  protected
  def after_confirmation_path_for(resource_name, resource)
    ua = request.env["HTTP_USER_AGENT"]
    if ua.include?('Mobile') || ua.include?('Android')
      users_confirmed_path
    else
      super
    end
  end
end
