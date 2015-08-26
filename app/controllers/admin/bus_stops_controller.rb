class Admin::BusStopsController < Admin::ApplicationController
  def index
  end

  def show
    @bus_stop = BusStop.find_by(id: params[:id])
    if @bus_stop.soft_destroyed?
      flash.now[:warning] = t('controller.admin.already_destroyed', soft_destroyed_at: @bus_stop.soft_destroyed_at)
    end

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

  def destroy
    bus_stop = BusStop.find_by(id: params[:id])
    unless bus_stop.soft_destroy
      redirect_to admin_bus_stop_path(bus_stop.id), alert: t('controller.bus_stops.cant_delete')
      return
    end
    redirect_to admin_bus_stop_path(bus_stop.id), notice: t('controller.bus_stops.soft_delete')
  end

  def photos_destroy
    bus_stop_photo = BusStopPhoto.find_by(id: params[:photo_id], bus_stop_id: params[:id])
    unless bus_stop_photo.destroy
      redirect_to_back alert: t('controller.bus_stops.cant_delete')
      return
    end
    redirect_to_back notice: t('controller.bus_stops.delete')
  end

  private
  def redirect_to_back(message)
    if request.referer
      redirect_to :back, message
    else
      redirect_to admin_bus_stop_path(params[:id]), message
    end
  end
end
