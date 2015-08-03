require "rails_helper"

RSpec.describe UsersController, :type => :routing do
  describe "routing" do
    it "route to #show" do
      expect(:get => "/users/1").to route_to("users#show", id: "1")
    end
    it "route to #new" do
      expect(:get => "/users/new").to route_to("users#new")
    end
    it "route to #create" do
      expect(:post => "/users").to route_to("users#create")
    end
    it "route to #edit" do
      expect(:get => "/users/1/edit").to route_to("users#edit", id: "1")
    end
    it "route to #update" do
      expect(:put => "/users/1").to route_to("users#update", id: "1")
    end
    it "route to #photos" do
      expect(:get => "/users/1/photos").to route_to("users#photos", id: "1")
    end
  end
end
