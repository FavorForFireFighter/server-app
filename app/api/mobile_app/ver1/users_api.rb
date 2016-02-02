module MobileApp
  module Ver1
    class UsersApi < Grape::API
      resource :users do

        # GET /api/app/users/show
        desc "User details"
        get :show, jbuilder: 'mobile_app/users/show.json.jbuilder' do
          authenticate_user!
        end

        # PATCH /api/app/users/photo
        desc "Delete user photos"
        params do
          requires :photos, type: Array[Integer], desc: "bus_stop_photo ids"
        end
        patch :photo, jbuilder: 'mobile_app/users/show.json.jbuilder' do
          authenticate_user!
          @user.bus_stop_photos.each do |photo|
            unless params[:photos].include? photo.id
              photo.destroy
            end
          end
          @user.reload
        end
      end
    end
  end
end
