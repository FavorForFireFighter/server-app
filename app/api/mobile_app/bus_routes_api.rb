module MobileApp
  class BusRoutesApi < Grape::API
    resource :bus_routes do

      # GET /api/app/bus_routes/show
      desc "Show bus_routes"
      params do
        requires :id, type: Integer, desc: "bus_route_information id"
      end
      get :show, jbuilder: 'mobile_app/bus_routes/show.json.jbuilder' do
        bus_route = BusRouteInformation.where(id: params[:id])
                        .with_bus_operation_company
                        .includes(:bus_stops)
                        .first
        if bus_route.blank?
          status 404
        end
        @bus_route_information = bus_route
      end

      # PATCH /api/app/bus_routes/edit
      desc "Edit bur_route_information"
      params do
        requires :id, type: Integer, desc: "bus_route_information id"
        requires :name, type: String, desc: "bus_line_name"
      end
      patch :edit, jbuilder: 'mobile_app/bus_routes/show.json.jbuilder' do
        bus_route_information = BusRouteInformation.where(id: params[:id])
                                    .with_bus_operation_company
                                    .includes(:bus_stops)
                                    .first
        if bus_route_information.blank?
          status 404
          return
        end
        bus_route_information.bus_line_name = params[:name]
        unless bus_route_information.save
          status 400
          @error = bus_route_information.errors.full_messages
          return
        end
        @bus_route_information = bus_route_information
      end

      # GET /api/app/bus_routes/companies
      desc "Search company"
      params do
        requires :name, type: String, desc: "Company name"
      end
      get :companies, jbuilder: 'mobile_app/bus_companies/list.json.jbuilder' do
        authenticate_user!
        companies = BusOperationCompany.search_by_keyword(params[:name]).order(:id)
        if companies.blank?
          status 404
        end
        @companies = companies
      end

      # GET /api/app/bus_routes/routes
      desc "Search route"
      params do
        requires :company_id, type: Integer, desc: "Company id"
      end
      get :routes, jbuilder: 'mobile_app/bus_routes/list.json.jbuilder' do
        authenticate_user!
        lines = BusRouteInformation.where(bus_operation_company_id: params[:company_id]).order(:id)
        if lines.blank?
          status 404
        end
        @lines = lines
      end

      # POST /api/app/bus_routes/create
      desc "Create route"
      params do
        requires :company_id, type: Integer, desc: "Company id"
        requires :company_name, type: String, desc: "Company name"
        requires :route_id, type: Integer, desc: "Line id"
        requires :route_name, type: String, desc: "Line name"
        requires :bus_type, type: Integer, desc: "bus type id"
      end
      post :create, jbuilder: 'mobile_app/bus_routes/create.json.jbuilder' do
        if params[:company_id] < 0
          company = BusOperationCompany.new(name: params[:company_name])
          unless company.save
            status 400
            @error = company.errors.full_messages
            return
          end
        else
          company = BusOperationCompany.find_by(id: params[:company_id])
        end

        if params[:route_id] < 0
          bus_type = params[:bus_type]
          unless BusRouteInformation::BusTypes.include? params[:bus_type]
            bus_type = 5
          end
          bus_route = BusRouteInformation.new(bus_type_id: bus_type, bus_operation_company_id: company.id, bus_line_name: params[:route_name])
          unless bus_route.save
            status 400
            @error = bus_route.errors.full_messages
            return
          end
        end

        @company = company
        @bus_route = bus_route
      end

    end


  end
end
