class Admin::PhotosController < Admin::ApplicationController
  def index
    @bus_stop_photos = BusStopPhoto.all.order(:id).includes(:bus_stop).references(:bus_stop)
  end
end
