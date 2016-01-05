require 'rails_helper'

RSpec.describe Admin::PhotosController, type: :controller do
  before do
    @admin = FactoryGirl.create(:admin)
  end
  let(:login) { sign_in :user, @admin }

  describe "GET #index" do
    before { login }
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "render photos template" do
      get :index
      expect(response).to render_template :index
      expect(assigns[:bus_stop_photos]).to be_truthy
    end
  end

  describe "GET #reporting" do
    before { login }
    it "returns http success" do
      get :reporting
      expect(response).to have_http_status(:success)
    end
    it "render report template" do
      get :reporting
      expect(response).to render_template :reporting
      expect(assigns[:bus_stop_photos]).to be_truthy
    end
  end

  describe "PATCH #reset_reporting" do
    before do
      login
      @bus_stop_photo = FactoryGirl.create(:bus_stop_photo_with_photo)
      @bus_stop_photo.reporting = 10
      @bus_stop_photo.save
    end
    it "redirect to reporting" do
      patch :reset_reporting, id: @bus_stop_photo.id
      expect(response).to redirect_to admin_photos_reporting_path
    end
    it "reset reporting" do
      patch :reset_reporting, id: @bus_stop_photo.id
      expect(@bus_stop_photo.reload.reporting).to eq 0
    end

    it "redirect to reporting when invalid id" do
      patch :reset_reporting, id: -1
      expect(response).to redirect_to admin_photos_reporting_path
    end
  end

end
