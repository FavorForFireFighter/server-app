module MobileApp
  class BusStopsApi < Grape::API
    resource :bus_stops do

      # GET/api/app/bus_stops/list
      desc "List bus_stops"
      params do
        requires :latitude, type: Float, desc: "latitude"
        requires :longitude, type: Float, desc: "longitude"
      end
      get :list, jbuilder: 'mobile_app/bus_stops/list.json.jbuilder' do
        bus_stops = BusStop.distance_sphere(params[:longitude], params[:latitude], 3000)
                        .order_by_distance(params[:longitude], params[:latitude])
        if bus_stops.blank?
          status 404
        end
        @bus_stops = bus_stops
      end

      # GET/api/app/bus_stops/show
      desc "Show bus_stops"
      params do
        requires :id, type: Integer, desc: "bus_stop id"
      end
      get :show, jbuilder: 'mobile_app/bus_stops/show.json.jbuilder' do
        bus_stop = BusStop.where(id: params[:id])
                       .includes(:bus_route_informations)
                       .includes(:prefecture)
                       .includes(:bus_stop_photos)
                       .first
        if bus_stop.blank?
          status 404
        end
        @bus_stop = bus_stop
      end
    end

  end
end
