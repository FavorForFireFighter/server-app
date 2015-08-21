require "rails_helper"

RSpec.describe UsersController, :type => :routing do
  describe "routing" do
    it "route to #show" do
      expect(:get => "/users/1").to route_to("users#show", id: "1")
    end
    it "route to #photos" do
      expect(:get => "/users/1/photos").to route_to("users#photos", id: "1")
    end
  end
end
