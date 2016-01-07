require 'rails_helper'

RSpec.describe StaticContentsController, type: :controller do

  describe "GET #privacy" do
    it "returns http success" do
      get :photo_guideline
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #terms_of_service" do
    it "returns http success" do
      get :terms_of_service
      expect(response).to have_http_status(:success)
    end
  end

=begin
  describe "GET #about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
    end
  end
=end

end
