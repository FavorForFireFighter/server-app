class AddReportingCountToBusStopPhoto < ActiveRecord::Migration
  def change
    add_column :bus_stop_photos, :reporting, :integer, default: 0
  end
end
