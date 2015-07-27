class Prefecture < ActiveRecord::Base
  has_many :bus_stops
  has_many :bus_operation_companies
end
