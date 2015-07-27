class BusRouteInformation < ActiveRecord::Base
  has_many :bus_stop_bus_route_informations
  has_many :bus_stops, through: :bus_stop_bus_route_informations
  belongs_to :bus_operation_company
end
