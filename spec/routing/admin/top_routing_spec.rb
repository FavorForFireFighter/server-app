require "rails_helper"

RSpec.describe Admin::TopController, :type => :routing do
  describe "routing" do
    it "route to #index" do
      expect(:get => "/admin/top/index").to route_to("admin/top#index")
    end
  end
end
