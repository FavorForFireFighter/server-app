require "rails_helper"

RSpec.describe Admin::PhotosController, :type => :routing do
  describe "routing" do
    it "route to #index" do
      expect(:get => "/admin/photos/index").to route_to("admin/photos#index")
    end
  end
end
