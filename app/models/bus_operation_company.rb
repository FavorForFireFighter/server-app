class BusOperationCompany < ActiveRecord::Base
  has_many :bus_route_informations, -> {order(:id)}
end
