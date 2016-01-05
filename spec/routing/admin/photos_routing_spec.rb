require "rails_helper"

RSpec.describe Admin::PhotosController, :type => :routing do
  describe "routing" do
    it "route to #index" do
      expect(:get => "/admin/photos/index").to route_to("admin/photos#index")
    end

    it "route to #reporting" do
      expect(:get => "/admin/photos/reporting").to route_to("admin/photos#reporting")
    end

    it "route to #reset_reporting" do
      expect(:patch => "/admin/photos/reset/1").to route_to("admin/photos#reset_reporting", id: "1")
    end
  end
end
