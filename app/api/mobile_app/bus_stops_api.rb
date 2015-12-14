module MobileApp
  class BusStopsApi < Grape::API
    resource :bus_stops do

      # GET/api/app/bus_stops/list
      desc "List bus_stops"
      params do
        requires :latitude, type: Float, desc: "latitude"
        requires :longitude, type: Float, desc: "longitude"
        optional :keyword, type: String, desc: "filter keyword"
      end
      get :list, jbuilder: 'bus_stops/list.json.jbuilder' do
        authenticate_user!
        bus_stops = BusStop.distance_sphere(params[:longitude], params[:latitude], 3000)
                        .order_by_distance(params[:longitude], params[:latitude])
                        .search_by_keyword(params[:keyword]).with_prefecture
        unless request.referer.present? && request.referer.include?("admin")
          bus_stops = bus_stops.without_soft_destroyed
        end
        if bus_stops.blank?
          status 404
        end
        @bus_stops = bus_stops
      end
    end

  end
end
