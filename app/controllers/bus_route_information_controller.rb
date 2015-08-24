class BusRouteInformationController < ApplicationController
  include SessionHelper

  before_action :let_login, except: [:show]

  def show
    @route_information = BusRouteInformation.with_bus_operation_company.find_by(id: params[:id])
  end

  def edit
    @route_information = BusRouteInformation.with_bus_operation_company.find_by(id: params[:id])
  end

  def update
    route_information = BusRouteInformation.find_by(id: params[:id])
    route_information.bus_line_name = edit_params[:bus_line_name]
    unless route_information.save
      @route_information = route_information
      render :edit
      return
    end

    redirect_to route_information, notice: t('controller.bus_route_information.updated')
  end

  private
  def edit_params
    params.require(:bus_route_information).permit(:bus_line_name)
  end
end
