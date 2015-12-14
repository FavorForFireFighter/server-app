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

      # GET /api/bus_routes/lines
      desc "Search line"
      params do
        requires :company_id, type: Integer, desc: "Company id"
      end
      get :lines, jbuilder: 'bus_routes/lines.json.jbuilder' do
        lines = BusRouteInformation.where(bus_operation_company_id: params[:company_id]).order(:id)
        if lines.blank?
          status 404
        end
        @lines = lines
      end

      # POST /api/bus_routes/register
      desc "Search line"
      params do
        requires :company_id, type: Integer, desc: "Company id"
        requires :company_name, type: String, desc: "Company name"
        requires :line_id, type: Integer, desc: "Line id"
        requires :line_name, type: String, desc: "Line name"
      end
      post :register, jbuilder: 'bus_routes/register.json.jbuilder' do
        if params[:company_id] < 0
          company = BusOperationCompany.new(name: params[:company_name])
          unless company.save
            status 400
            @result = false
            return
          end
        else
          company = BusOperationCompany.find_by(id: params[:company_id])
        end

        if params[:line_id] < 0
          line = BusRouteInformation.new(bus_type_id: 1, bus_operation_company_id: company.id, bus_line_name: params[:line_name])
          unless line.save
            status 400
            @result = false
            return
          end
        end

        @result = true
        @company = company
        @line = line
      end

      # GET /api/bus_routes/line
      desc "Get Line"
      params do
        requires :line_id, type: Integer, desc: "bus_route_information_id"
      end
      get :line, jbuilder: 'bus_routes/line.json.jbuilder' do
        @route_information = BusRouteInformation.find_by(id: params[:line_id])
        if @route_information.blank?
          status 404
        end
      end

    end


  end
end
