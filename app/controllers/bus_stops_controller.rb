class BusStopsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
  end

  def show
    @bus_stop = BusStop.without_soft_destroyed.find_by(id: params[:id])

    @information = {}
    @photos = @bus_stop.bus_stop_photos.includes(:user).references(:user).order("bus_stop_photos.created_at DESC")
  end

  def new
    if params[:id].blank?
      @bus_stop = BusStop.new
    else
      bus_stop_orig = BusStop.without_soft_destroyed.find_by(id: params[:id])
      if bus_stop_orig.blank?
        @bus_stop = BusStop.new
      else
        @bus_stop = bus_stop_orig.dup
        @bus_stop.location_updated_at = nil
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
    @location_updated_at = params[:location_updated_at]

    bus_stop = BusStop.new _params
    bus_stop.last_modify_user_id = current_user.id
    bus_stop.status = _params[:status]

    unless bus_stop.set_location params[:latitude], params[:longitude]
      flash.now[:error] = t('controller.bus_stops.invalid_location')
      @bus_seop = bus_stop
      @prefectures = Prefecture.all.order(:id)
      render :new
      return
    end

    if params[:location_updated_at] != "false"
      bus_stop.location_updated_at = Time.zone.now
    end

    unless bus_stop.save
      @bus_stop = bus_stop
      @prefectures = Prefecture.all.order(:id)
      render :new
      return
    end

    redirect_to bus_stop, {notice: t('controller.bus_stops.create')}
  end

  def edit
    @bus_stop = BusStop.without_soft_destroyed.find_by(id: params[:id])
    @prefectures = Prefecture.all.order(:id)
    @latitude = @bus_stop.location.try(:y)
    @longitude = @bus_stop.location.try(:x)
    @location_updated_at = @bus_stop.location_updated_at
  end

  def update
    _params = new_params
    @latitude = params[:latitude]
    @longitude = params[:longitude]

    bus_stop = BusStop.without_soft_destroyed.find_by(id: params[:id])
    bus_stop.attributes = _params
    puts _params
    bus_stop.status = _params[:status]
    bus_stop.last_modify_user_id = current_user.id

    unless bus_stop.set_location params[:latitude], params[:longitude]
      flash.now[:error] = t('controller.bus_stops.invalid_location')
      @bus_stop = bus_stop
      render :edit
      @prefectures = Prefecture.all.order(:id)
      return
    end

    if params[:location_updated_at] == "false"
      bus_stop.location_updated_at = nil
    elsif params[:location_updated_at] == "true"
      bus_stop.location_updated_at = Time.zone.now
    end

    bus_stop.touch
    unless bus_stop.save
      @bus_seop = bus_stop
      @prefectures = Prefecture.all.order(:id)
      render :edit
      return
    end

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
    params.require(:bus_stop).permit(:name, :status, :prefecture_id)
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
