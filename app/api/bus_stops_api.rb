class BusStopsApi < Grape::API
  resource :bus_stops do

    # GET/api/bus_stops/list
    desc "List bus_stops"
    params do
      requires :latitude, type: Float, desc: "latitude"
      requires :longitude, type: Float, desc: "longitude"
      optional :keyword, type: String, desc: "filter keyword"
      optional :zoom, type: Integer, desc: "zoom level"
    end
    get :list, jbuilder: 'bus_stops/list.json.jbuilder' do
      zoom = params[:zoom].nil? || params[:zoom] > 13 ? 3000 : 1000000000
      lat =  params[:latitude].blank? ? 19.690435317911682 : params[:latitude]
      lng = params[:longitude].blank? ? 100.81561088562013 : params[:longitude]

      bus_stops = BusStop.distance_sphere(lng, lat, zoom)
                      .order_by_distance(lng, lat)
                      .search_by_keyword(params[:keyword])
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
