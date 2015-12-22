module DeviseTokenAuthOverrides
  class SessionsController < DeviseTokenAuth::SessionsController
    def render_create_success
      render json: {
          status: "success",
          data: {
              id: @resource.id,
              username: @resource.username
          }
      }
    end

    def render_create_error_not_confirmed
      render json: {
          success: false,
          errors: [I18n.t("devise_token_auth.sessions.not_confirmed", email: @resource.email)]
      }, status: 401
    end

    def render_create_error_bad_credentials
      render json: {
          errors: [I18n.t("devise_token_auth.sessions.bad_credentials")]
      }, status: 401
    end

  end
end
