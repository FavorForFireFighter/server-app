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
      devise_parameter_sanitizer.for(:sign_up) << [:username, :email]
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:account_update) << :email
      devise_parameter_sanitizer.for(:sign_up) << :email
    end
  end
end
