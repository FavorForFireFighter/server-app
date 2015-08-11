require "rails_helper"

RSpec.describe Admin::BusStopsController, :type => :routing do
  describe "routing" do
    it "route to #index" do
      expect(:get => "/admin/bus_stops/").to route_to("admin/bus_stops#index")
    end
    it "route to #show" do
      expect(:get => "/admin/bus_stops/1").to route_to("admin/bus_stops#show", id: "1")
    end
    it "route to #photos_destroy" do
      expect(:delete => "/admin/bus_stops/1/photos_destroy/2").to route_to("admin/bus_stops#photos_destroy", id: "1", photo_id: "2")
    end
  end
end
