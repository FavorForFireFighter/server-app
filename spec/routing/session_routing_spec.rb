require "rails_helper"

RSpec.describe SessionController, :type => :routing do
  describe "routing" do
    it "route to #index" do
      expect(:get => "/session/index").to route_to("session#index")
    end
    it "route to #login" do
      expect(:post => "/session/login").to route_to("session#login")
    end
    it "route to #logout" do
      expect(:get => "/session/logout").to route_to("session#logout")
    end
  end
end
