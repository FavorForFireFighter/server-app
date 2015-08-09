# coding: utf-8
require 'csv'
new_csv = File.join(File.dirname(__FILE__), 'company_line_list.csv')
p "output to #{new_csv}"
CSV.open(new_csv, 'w', {encoding: "SJIS", row_sep: "\r\n", force_quotes: true}) do |csv|
  csv << ["会社名", "路線名", "路線区分", "路線区分(テキスト)"]
  BusOperationCompany.order(:id).includes(:bus_route_informations).each do |company|
    company.bus_route_informations.each do |route|
      csv << [company.name, route.bus_line_name, route.bus_type_id, BusRouteInformation::BusTypes[route.bus_type_id]]
    end
  end
end
