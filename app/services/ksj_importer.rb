# coding: utf-8

require 'nokogiri'

class KsjImporter

  FILENAME = "P11-10_%s-jgd-g.xml"
  
  class << self

    def import(file_path, prefecture_id)
      full_path = get_full_path(file_path, prefecture_id)
      parse_all(full_path, prefecture_id)
    end

    def import_all(file_path)
      (1..47).each do |prefecture_id|
        import(file_path, prefecture_id)
      end
    end
    
    private
    def get_full_path(file_path, prefecture_id)
      replace_str = "%02d" % prefecture_id
      import_file = FILENAME % replace_str
      File.join(file_path, import_file)
    end

    def make_pos_hash(doc)
      hash = Hash.new
      doc.xpath('//gml:Point').each do |point|
        id = point.attribute("id").value
        pos = point.xpath('gml:pos').first.text.split(" ")
        hash["#" + id] = pos
      end
      hash
    end
    
    def parse_all(full_path, prefecture_id)
      f = open(full_path)
      doc = Nokogiri::XML(f)
      f.close
      pos_hash = make_pos_hash(doc)
      doc.xpath('//ksj:BusStop').each do |bus_stop|
        href = bus_stop.xpath("ksj:position").first.attribute("href").value
        pos = pos_hash[href]
        latitude = pos[0]
        longitude = pos[1]
        name = bus_stop.xpath("ksj:busStopName").first.text
        bus_stop_object = BusStop.create(name: name, prefecture_id: prefecture_id, location: "POINT(#{longitude} #{latitude})")
        bus_stop.xpath("ksj:busRouteInformation//ksj:BusRouteInformation").each do |bus_route_information|
          bus_type = bus_route_information.xpath("ksj:busType").first.text.to_i
          bus_operation_company = bus_route_information.xpath("ksj:busOperationCompany").first.text
          bus_operation_company_object = BusOperationCompany.where(name: bus_operation_company).first
          unless bus_operation_company_object
            bus_operation_company_object = BusOperationCompany.create(name: bus_operation_company)
          end
          bus_line_name = bus_route_information.xpath("ksj:busLineName").first.text
          bus_route_information_object = BusRouteInformation.where(bus_type_id: bus_type, bus_operation_company: bus_operation_company_object, bus_line_name: bus_line_name).first
          unless bus_route_information_object
            bus_route_information_object = BusRouteInformation.create(bus_type_id: bus_type, bus_operation_company: bus_operation_company_object, bus_line_name: bus_line_name)
          end
          bus_stop_object.bus_route_informations << bus_route_information_object
          bus_stop_object.save
        end
        #p href, latitude, longitude, name
      end
      nil
    end
  end
end


