class BusOperationCompany < ActiveRecord::Base
  has_many :bus_route_informations
  belongs_to :prefecture
end
