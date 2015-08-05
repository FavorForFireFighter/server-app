class BusStopsController < ApplicationController
  include SessionHelper

  def index
  end

  def show
    @bus_stop = BusStop.find_by(id: params[:id])

    @information = {}
    @bus_stop.bus_route_informations.each do |route_information|
      company = route_information.bus_operation_company
      if @information.has_key?(company.id)
        @information[company.id][:routes].concat [route_information]
      else
        @information[company.id] = {company: company, routes: [route_information]}
      end
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def photos_new
  end

  def photos_create
  end

  def photos_destroy
  end
end
