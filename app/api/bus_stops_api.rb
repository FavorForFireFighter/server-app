class BusStopsApi < Grape::API
  resource :bus_stops do

    # GET/api/bus_stops/list
    desc "List bus_stops"
    params do
      requires :latitude, type: Float, desc: "latitude"
      requires :longitude, type: Float, desc: "longitude"
    end
    get :list, jbuilder: 'bus_stops/list.json.jbuilder' do
      bus_stops = BusStop.distance_sphere(params[:longitude], params[:latitude], 1000).with_prefecture
      if bus_stops.blank?
        status 404
      end
      @bus_stops = bus_stops
    end
  end

end