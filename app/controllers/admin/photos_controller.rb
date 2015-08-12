class Admin::PhotosController < Admin::ApplicationController
  def index
    if request.xhr?
      bus_stop_photos = BusStopPhoto.order(:id).includes(:bus_stop).references(:bus_stop).page(params[:page]).per(1)
      paginator = view_context.create_pager_with_entries(bus_stop_photos, nil, true)
      list = render_to_string partial: 'common/bus_stop_photo_list', locals: {bus_stop_photos: bus_stop_photos}
      render json: {paginator: paginator, list: list}
      return
    end
    @bus_stop_photos = BusStopPhoto.order(:id).includes(:bus_stop).references(:bus_stop).page(params[:page]).per(1)
  end
end
