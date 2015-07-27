class BusStopBusRouteInformation < ActiveRecord::Base
  belongs_to :bus_stop
  belongs_to :bus_route_information
end
