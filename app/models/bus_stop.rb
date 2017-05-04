class BusStop < ActiveRecord::Base
  has_paper_trail
  soft_deletable
  belongs_to :last_modify_user, :class_name => User, :foreign_key => :last_modify_user_id
  has_many :bus_stop_photos

  scope :distance_sphere, -> (longitude, latitude, meter) {
    where("ST_DWithin(bus_stops.location, ST_GeomFromText('POINT(:longitude :latitude)', 4326), :meter)",
          {:longitude => longitude, :latitude => latitude, :meter => meter})
  }

  scope :order_by_distance, ->(longitude, latitude) {
    order("ST_Distance_Sphere(bus_stops.location::GEOMETRY, ST_GeomFromText('POINT(#{longitude} #{latitude})',4326))")
  }


  scope :search_by_keyword, ->(keyword) {
    where("name LIKE :keyword", {keyword: "%"+keyword.gsub(/[\\%_]/) { |m| "\\#{m}" }+"%"}) unless keyword.blank?
  }

  enum status: { fire_found: 0, fire_got_under: 1 }

  validates :name, presence: true

  def set_location(latitude, longitude)
    if latitude.blank? || longitude.blank?
      return false
    end

    _latitude = latitude.to_f
    _longitude = longitude.to_f
    if -90 < _latitude and _latitude < 90
      if -180 < _longitude and _longitude < 180
        self.location = "POINT(#{_longitude} #{_latitude})"
        return true
      end
    end
    return false
  end


end
