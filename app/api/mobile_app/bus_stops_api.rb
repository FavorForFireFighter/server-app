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
        if bus_stops.blank?
          status 404
        end
        @bus_stops = bus_stops
      end

      # GET/api/app/bus_stops/show
      desc "Show bus_stop"
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
          @error = "BusStop not found"
        end
        @bus_stop = bus_stop
      end

      # PATCH /api/app/bus_stops/edit
      desc "Edit bus_stop"
      params do
        requires :id, type: Integer, desc: "bus_stop id"
        requires :name, type: String, desc: "bus_stop name"
        requires :prefecture, type: Integer, desc: "prefecture id"
        requires :latitude, type: Float, values: -90.0..+90.0, desc: "latitude"
        requires :longitude, type: Float, values: -180.0..+180.0, desc: "longitude"
        requires :location_updated_at, type: Boolean, desc: "location is updated"
        requires :routes, type: Array[Integer], desc: "bus_route_information ids"
        requires :photos, type: Array[Integer], desc: "bus_stop_photo ids"
        optional :new_photos, desc: "new bus_stop_photos", type: Array do
          requires :title, type: String
          requires :photo, type: String
        end
      end
      patch :edit, jbuilder: 'mobile_app/bus_stops/show.json.jbuilder' do
        authenticate_user!
        bus_stop = BusStop.without_soft_destroyed.find_by(id: params[:id])
        if bus_stop.blank?
          status 400
        else
          routes = params[:routes].reject(&:blank?)
          if routes.blank?
            @error = "RouteInformation is required."
            return
          end

          bus_stop.last_modify_user_id = @user.id
          bus_stop.name = params[:name]
          bus_stop.prefecture.id = params[:prefecture]

          unless bus_stop.set_location params[:latitude], params[:longitude]
            @error = "Invalid location."
            return
          end

          if params[:location_updated_at]
            bus_stop.location_updated_at = Time.zone.now
          end

          unless bus_stop.save
            @error = bus_stop.errors.full_messages.first
            return
          end

          # update bus_route_information
          route_information = BusRouteInformation.where(id: params[:routes])
          bus_stop.bus_route_informations = route_information

          # update bus_stop_photos
          bus_stop.bus_stop_photos.each do |photo|
            unless params[:photos].include? photo.id
              photo.destroy
            end
          end

          unless params[:new_photos].blank?
            params[:new_photos].each do |photo|
              bus_stop_photo = BusStopPhoto.new
              bus_stop_photo.photo = photo.photo
              bus_stop_photo.title = photo.title
              bus_stop_photo.bus_stop_id = bus_stop.id
              bus_stop_photo.user_id = @user.id
              unless bus_stop_photo.save
                @error = bus_stop_photo.errors.full_messages
                return
              end
            end
          end
          @bus_stop = bus_stop
        end
      end

      # POST /api/app/bus_stops/create
      desc "Create bus_stop"
      params do
        requires :name, type: String, desc: "bus_stop name"
        requires :prefecture, type: Integer, desc: "prefecture id"
        requires :latitude, type: Float, desc: "latitude"
        requires :longitude, type: Float, desc: "longitude"
        requires :location_updated_at, type: Boolean, desc: "location is updated"
        requires :routes, type: Array[Integer], desc: "bus_route_information ids"
      end
      post :create, jbuilder: 'mobile_app/bus_stops/show.json.jbuilder' do
        authenticate_user!
        bus_stop = BusStop.new
        routes = params[:routes].reject(&:blank?)
        if routes.blank?
          @error = "RouteInformation is required."
          return
        end

        bus_stop.last_modify_user_id = @user.id
        bus_stop.name = params[:name]
        bus_stop.prefecture = Prefecture.find_by id: params[:prefecture]

        unless bus_stop.set_location params[:latitude], params[:longitude]
          @error = "Invalid location."
          return
        end

        if params[:location_updated_at]
          bus_stop.location_updated_at = Time.zone.now
        end

        unless bus_stop.save
          @error = bus_stop.errors.full_messages.first
          return
        end

        # update bus_route_information
        route_information = BusRouteInformation.where(id: params[:routes])
        bus_stop.bus_route_informations = route_information

        @bus_stop = bus_stop
      end

    end
  end
end
