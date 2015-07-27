class BusStopPhoto < ActiveRecord::Base
  belongs_to :bus_stop
  belongs_to :user
end
