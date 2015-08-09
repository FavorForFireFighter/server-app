class BusRouteInformation < ActiveRecord::Base
  has_many :bus_stop_bus_route_informations
  has_many :bus_stops, through: :bus_stop_bus_route_informations
  belongs_to :bus_operation_company

  # http://nlftp.mlit.go.jp/ksj/jpgis/codelist/BusClassCd.html
  BusTypes = {
    1 => "路線バス（民間）",
    2 => "路線バス（公営）",
    3 => "コミュニティバス",
    4 => "デマンドバス",
    5 => "その他"
  }

end
