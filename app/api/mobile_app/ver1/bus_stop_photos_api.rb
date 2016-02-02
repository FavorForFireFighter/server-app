module MobileApp
  module Ver1
    class BusStopPhotosApi < Grape::API
      resource :bus_stop_photos do

        # PATCH /api/app/bus_stop_photos/report
        desc "List bus_stops"
        params do
          requires :id, type: Integer, desc: "bus_stop_photo id"
        end
        patch :report, jbuilder: 'mobile_app/bus_stop_photos/report.json.jbuilder' do
          bus_stop_photo = BusStopPhoto.find_by id: params[:id]
          if bus_stop_photo.blank?
            status 404
            return
          end
          bus_stop_photo.reporting = bus_stop_photo.reporting + 1
          if bus_stop_photo.save
            @bus_stop_photo = bus_stop_photo
          else
            status 400
            @error = bus_stop_photo.errors.full_messages
          end
        end
      end
    end
  end
end
