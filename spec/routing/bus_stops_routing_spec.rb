require "rails_helper"

RSpec.describe BusStopsController, :type => :routing do
  describe "routing" do
    it "route to #index" do
      expect(:get => "/bus_stops/").to route_to("bus_stops#index")
    end
    it "route to #show" do
      expect(:get => "/bus_stops/1").to route_to("bus_stops#show", id: "1")
    end
    it "route to #new" do
      expect(:get => "/bus_stops/new").to route_to("bus_stops#new")
    end
    it "route to #create" do
      expect(:post => "/bus_stops").to route_to("bus_stops#create")
    end
    it "route to #edit" do
      expect(:get => "/bus_stops/1/edit").to route_to("bus_stops#edit", id: "1")
    end
    it "route to #update" do
      expect(:put => "/bus_stops/1").to route_to("bus_stops#update", id: "1")
    end
    it "route to #photos_new" do
      expect(:get => "/bus_stops/1/photos/new").to route_to("bus_stops#photos_new", id: "1")
    end
    it "route to #photos_create" do
      expect(:post => "/bus_stops/1/photos/create").to route_to("bus_stops#photos_create", id: "1")
    end
    it "route to #photos_destroy" do
      expect(:delete => "/bus_stops/1/photos/2").to route_to("bus_stops#photos_destroy", id: "1", photo_id: "2")
    end
  end
end
