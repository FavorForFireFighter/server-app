class AddIndexToBusStopBusRouteInformation < ActiveRecord::Migration
  def change
    add_index :bus_stop_bus_route_informations, :bus_stop_id
    add_index :bus_stop_bus_route_informations, :bus_route_information_id, name: "index_to_bus_route_information_id"
  end
end
