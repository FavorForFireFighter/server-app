class BusOperationCompany < ActiveRecord::Base
  has_many :bus_route_informations, -> {order(:id)}

  validates :name, presence: true

  scope :search_by_keyword, ->(keyword) {
    where("name LIKE :keyword", {keyword: "%"+keyword.gsub(/[\\%_]/) { |m| "\\#{m}" }+"%"}) unless keyword.blank?
  }
end
