class CreateBusStopBusRouteInformations < ActiveRecord::Migration
  def change
    create_table :bus_stop_bus_route_informations do |t|
      t.integer :bus_stop_id
      t.integer :bus_route_information_id

      t.timestamps null: false
    end
  end
end
