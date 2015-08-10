class BusStopsController < ApplicationController
  include SessionHelper

  before_action :let_login, except: [:index, :show]

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
    @bus_stop = BusStop.new
    @prefectures = Prefecture.all.order(:id)
    @route_information = []
  end

  def create
    _params = new_params

    bus_stop = BusStop.new _params
    bus_stop.last_modify_user_id = current_user.id
    if params[:bus_route_information].blank?
      flash.now[:error] = t('controller.bus_stops.no_route_information')
      @bus_stop = bus_stop
      @prefectures = Prefecture.all.order(:id)
      @route_information = []
      render :new
      return
    end

    unless bus_stop.set_location params[:latitude], params[:longitude]
      flash.now[:error] = t('controller.bus_stops.invalid_location')
      @bus_stop = bus_stop
      @prefectures = Prefecture.all.order(:id)
      @route_information = BusRouteInformation.where(id: params[:bus_route_information][:id])
      render :new
      return
    end

    if params[:location_updated_at] != "false"
      bus_stop.location_updated_at = Time.zone.now
    end

    unless bus_stop.save
      @bus_stop = bus_stop
      @prefectures = Prefecture.all.order(:id)
      @route_information = BusRouteInformation.where(id: params[:bus_route_information][:id]).with_bus_operation_company
      render :new
      return
    end

    route_information = BusRouteInformation.where(id: params[:bus_route_information][:id])
    bus_stop.bus_route_informations = route_information
    redirect_to bus_stop, {notice: t('controller.bus_stops.create')}
  end

  def edit
    @bus_stop = BusStop.find_by(id: params[:id])
    @prefectures = Prefecture.all.order(:id)
    @route_information = @bus_stop.bus_route_informations.with_bus_operation_company
  end

  def update
    _params = new_params

    bus_stop = BusStop.find_by(id: params[:id])
    bus_stop.attributes = _params
    bus_stop.last_modify_user_id = current_user.id
    if params[:bus_route_information].blank?
      flash.now[:error] = t('controller.bus_stops.no_route_information')
      @bus_stop = bus_stop
      @prefectures = Prefecture.all.order(:id)
      @route_information = []
      render :edit
      return
    end

    unless bus_stop.set_location params[:latitude], params[:longitude]
      flash.now[:error] = t('controller.bus_stops.invalid_location')
      @bus_stop = bus_stop
      @prefectures = Prefecture.all.order(:id)
      @route_information = BusRouteInformation.where(id: params[:bus_route_information][:id])
      render :edit
      return
    end

    if params[:location_updated_at] == "true"
      bus_stop.location_updated_at = Time.zone.now
    end

    bus_stop.touch
    unless bus_stop.save
      @bus_stop = bus_stop
      @prefectures = Prefecture.all.order(:id)
      @route_information = BusRouteInformation.where(id: params[:bus_route_information][:id]).with_bus_operation_company
      render :edit
      return
    end

    route_information = BusRouteInformation.where(id: params[:bus_route_information][:id])
    bus_stop.bus_route_informations = route_information
    redirect_to bus_stop, {notice: t('controller.bus_stops.edit')}
  end

  def photos_new
  end

  def photos_create
  end

  def photos_destroy
  end

  private
  def new_params
    params.require(:bus_stop).permit(:name, :prefecture_id)
  end
end
