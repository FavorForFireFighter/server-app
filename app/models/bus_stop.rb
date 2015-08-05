class BusStop < ActiveRecord::Base
  has_many :bus_stop_bus_route_informations
  has_many :bus_route_informations, through: :bus_stop_bus_route_informations
  belongs_to :prefecture
  belongs_to :user, :foreign_key => :last_modify_user_id
  has_many :bus_stop_photos

  scope :distance_sphere, -> (longitude, latitude, meter) {
    where("ST_DWithin(bus_stops.location, ST_GeomFromText('POINT(:longitude :latitude)', 4326), :meter)",
          {:longitude => longitude, :latitude => latitude, :meter => meter})
  }

  scope :with_prefecture, ->() {
    includes(:prefecture)
  }

  scope :with_bus_route_information, ->() {
    includes(:bus_route_informations)
  }

  scope :search_by_keyword, ->(keyword) {
    where("name LIKE :keyword", {keyword: "%"+keyword.gsub(/[\\%_]/) { |m| "\\#{m}" }+"%"}) unless keyword.blank?
  }

end
