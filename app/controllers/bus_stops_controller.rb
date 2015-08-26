class BusStopsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

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
    @photos = @bus_stop.bus_stop_photos.includes(:user).references(:user).order("bus_stop_photos.created_at DESC")
  end

  def new
    if params[:id].blank?
      @bus_stop = BusStop.new
      @route_information = []
    else
      bus_stop_orig = BusStop.find_by(id: params[:id])
      if bus_stop_orig.blank?
        @bus_stop = BusStop.new
        @route_information = []
      else
        @bus_stop = bus_stop_orig.dup
        @route_information = bus_stop_orig.bus_route_informations.with_bus_operation_company
      end
    end

    @prefectures = Prefecture.all.order(:id)
    @latitude = @bus_stop.location.try(:y)
    @longitude = @bus_stop.location.try(:x)
  end

  def create
    _params = new_params
    @latitude = params[:latitude]
    @longitude = params[:longitude]

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
    @latitude = @bus_stop.location.try(:y)
    @longitude = @bus_stop.location.try(:x)
  end

  def update
    _params = new_params
    @latitude = params[:latitude]
    @longitude = params[:longitude]

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
    @bus_stop_photo = BusStopPhoto.new(bus_stop_id: params[:id])
  end

  def photos_create
    bus_stop_photo = BusStopPhoto.new new_photo_params
    bus_stop_photo.bus_stop_id = params[:id]
    bus_stop_photo.user_id = current_user.id
    unless bus_stop_photo.save
      @bus_stop_photo = bus_stop_photo
      render :photos_new
      return
    end
    redirect_to bus_stop_path(params[:id]), {notice: t('controller.bus_stops.add_photo')}
  end

  def photos_destroy
    bus_stop_photo = BusStopPhoto.find_by(id: params[:photo_id], bus_stop_id: params[:id])
    if bus_stop_photo.user.id != current_user.id
      redirect_to_back alert: t('controller.bus_stops.not_allow_delete')
      return
    end

    unless bus_stop_photo.destroy
      redirect_to_back alert: t('controller.bus_stops.cant_delete')
      return
    end
    redirect_to_back notice: t('controller.bus_stops.delete')
  end

  private
  def new_params
    params.require(:bus_stop).permit(:name, :prefecture_id)
  end

  def new_photo_params
    params.require(:bus_stop_photo).permit(:photo, :title)
  end

  def redirect_to_back(message)
    if request.referer
      redirect_to :back, message
    else
      redirect_to bus_stop_path(params[:id]), message
    end
  end
end
