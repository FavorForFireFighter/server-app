module DeviseTokenAuthOverrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController

    def render_update_success
      res = {id: @resource.id, email: @resource.email, username: @resource.username}
      render json: {
          status: 'success',
          data: res.as_json
      }
    end

    def render_update_error
      render json: {
          status: 'error',
          error:@resource.errors.full_messages
      }, status: 403
    end

    def render_update_error_user_not_found
      render json: {
          status: 'error',
          errors: [I18n.t("devise_token_auth.registrations.user_not_found")]
      }, status: 404
    end
  end
end