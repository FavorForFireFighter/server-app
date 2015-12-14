module MobileApp
  class Base < Grape::API
    prefix 'api/app'
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
          authenticate_error!
        end
      end

    end

    mount MobileApp::BusStopsApi
    mount MobileApp::BusRoutesApi
    mount MobileApp::UsersApi
  end
end