class Admin::PhotosController < Admin::ApplicationController
  def index
    if request.xhr?
      bus_stop_photos = BusStopPhoto.includes(:bus_stop).references(:bus_stop)
      bus_stop_photos = bus_stop_photos.merge(BusStop.search_by_keyword(params[:keyword])) if params[:keyword].present?
      bus_stop_photos = bus_stop_photos.merge(BusStop.where(prefecture_id: params[:prefecture])) if params[:prefecture].present?
      bus_stop_photos = bus_stop_photos.order("bus_stop_photos.created_at DESC").page(params[:page])

      paginator = view_context.create_pager_with_entries(bus_stop_photos, search_params, true)
      list = render_to_string partial: 'common/bus_stop_photo_list', locals: {bus_stop_photos: bus_stop_photos}
      render json: {paginator: paginator, list: list, page: params[:page]}
      return
    end
    @bus_stop_photos = BusStopPhoto.order("bus_stop_photos.created_at DESC").includes(:bus_stop).references(:bus_stop).page(params[:page])
  end

  def reporting
    @bus_stop_photos = BusStopPhoto.where("bus_stop_photos.reporting > 0")
                           .order("bus_stop_photos.reporting DESC")
                           .includes(:bus_stop)
                           .references(:bus_stop)
                           .page(params[:page])
  end

  def reset_reporting
    bus_stop_photo = BusStopPhoto.find_by(id: params[:id])
    if bus_stop_photo.blank?
      redirect_to admin_photos_reporting_path, alert: t('controller.bus_stop_photos.cant_reset')
      return
    end

    bus_stop_photo.reporting = 0
    unless bus_stop_photo.save
      redirect_to admin_photos_reporting_path, alert: t('controller.bus_stop_photos.cant_reset')
      return
    end
    redirect_to admin_photos_reporting_path, notice: t('controller.bus_stop_photos.reset')
  end

  private
  def search_params
    params.permit(:keyword, :prefecture, :page)
  end
end
