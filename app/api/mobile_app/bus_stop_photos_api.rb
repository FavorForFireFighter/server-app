module MobileApp
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
          @error = 'not found photo'
          return
        end
        bus_stop_photo.reporting = bus_stop_photo.reporting + 1
        unless bus_stop_photo.save
          @bus_stop_photo = bus_stop_photo
        end
      end

    end
  end
end
