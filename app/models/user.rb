class User < ActiveRecord::Base
  has_secure_password
  has_many :bus_stop_photos
end
