require "rails_helper"

RSpec.describe BusRouteInformationController, :type => :routing do
  describe "routing" do
    it "route to #show" do
      expect(:get => "/bus_route_information/1").to route_to("bus_route_information#show", id: "1")
    end
    it "route to #edit" do
      expect(:get => "/bus_route_information/1/edit").to route_to("bus_route_information#edit", id: "1")
    end
    it "route to #update" do
      expect(:put => "/bus_route_information/1").to route_to("bus_route_information#update", id: "1")
    end
  end
end
