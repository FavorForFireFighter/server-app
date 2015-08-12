require "rails_helper"

RSpec.describe Admin::UsersController, :type => :routing do
  describe "routing" do
    it "route to #index" do
      expect(:get => "/admin/users/index").to route_to("admin/users#index")
    end
    it "route to #show" do
      expect(:get => "/admin/users/1").to route_to("admin/users#show", id: "1")
    end
    it "route to #edit" do
      expect(:get => "/admin/users/1/edit").to route_to("admin/users#edit", id: "1")
    end
    it "route to #update" do
      expect(:patch => "/admin/users/1").to route_to("admin/users#update", id: "1")
    end
    it "route to #destroy" do
      expect(:delete => "/admin/users/1").to route_to("admin/users#destroy", id: "1")
    end
    it "route to #photos_index" do
      expect(:get => "/admin/users/1/photos").to route_to("admin/users#photos_index", id: "1")
    end
  end
end
