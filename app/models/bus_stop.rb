class BusStop < ActiveRecord::Base
  has_many :bus_stop_bus_route_informations
  has_many :bus_route_informations, through: :bus_stop_bus_route_informations
  belongs_to :prefecture
  has_many :bus_stop_photos
end
