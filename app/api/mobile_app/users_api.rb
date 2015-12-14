module MobileApp
  class UsersApi < Grape::API
    resource :users do

      # GET /api/app/users/show
      desc "User details"
      get :show, jbuilder: 'mobile_app/users/show.json.jbuilder' do
        authenticate_user!
      end
    end
  end
end
