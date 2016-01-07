require "rails_helper"

RSpec.describe StaticContentsController, :type => :routing do
  describe "routing" do
    it "route to #privacy" do
      expect(:get => "/static_contents/photo_guideline").to route_to("static_contents#photo_guideline")
    end
    it "route to #terms_of_service" do
      expect(:get => "/static_contents/terms_of_service").to route_to("static_contents#terms_of_service")
    end
=begin
    it "route to #about" do
      expect(:get => "/static_contents/about").to route_to("static_contents#about")
    end
=end
  end
end
