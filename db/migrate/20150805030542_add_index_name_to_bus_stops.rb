class AddIndexNameToBusStops < ActiveRecord::Migration
  def change
    add_index :bus_stops, :name
  end
end
