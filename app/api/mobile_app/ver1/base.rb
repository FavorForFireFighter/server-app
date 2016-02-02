module MobileApp
  module Ver1
    class Base < Grape::API
      prefix 'api/app'
      version 'v1'
      helpers do
        def authenticate_error!
          h = {'Access-Control-Allow-Origin' => "*",
               'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(",")}
          error!('You need to login to use the app.', 401, h)
        end

        def authenticate_user!
          uid = request.headers['Uid']
          token = request.headers['Access-Token']
          client = request.headers['Client']
          @user = User.find_by_uid(uid)

          unless @user && @user.valid_token?(token, client)
            delete_invalid_token @user, client
            authenticate_error!
          end
          set_new_auth_header client
        end

        def delete_invalid_token(user, client)
          if user
            tokens = user.tokens.delete client
            if tokens.present?
              user.save
            end
          end
        end

        def set_new_auth_header(client)
          new_auth_header = @user.create_new_auth_token(client)
          header 'Access-Token', new_auth_header['access-token']
          header 'UID', new_auth_header['uid']
          header 'Client', new_auth_header['client']
          header 'Expiry', new_auth_header['expiry']
        end

      end

      mount MobileApp::Ver1::BusStopsApi
      mount MobileApp::Ver1::BusRoutesApi
      mount MobileApp::Ver1::UsersApi
      mount MobileApp::Ver1::BusStopPhotosApi
    end
  end
end