module DeviseTokenAuth
  class ApplicationController < DeviseController
    protect_from_forgery with: :null_session
    before_action :configure_permitted_parameters, if: :devise_controller?
    include DeviseTokenAuth::Concerns::SetUserByToken

    protected

    def resource_class(m=nil)
      if m
        mapping = Devise.mappings[m]
      else
        mapping = Devise.mappings[resource_name] || Devise.mappings.values.first
      end

      mapping.to

    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys:[:email])
      devise_parameter_sanitizer.permit(:sign_up, keys:[:email])
    end
  end
end
