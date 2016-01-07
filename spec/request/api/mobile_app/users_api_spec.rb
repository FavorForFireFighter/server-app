require 'rails_helper'

RSpec.describe MobileApp::UsersApi, :type => :request do

  before do
    @user = FactoryGirl.create(:user)
  end
  let(:login) { headers.merge! @user.create_new_auth_token @user.email }

  describe "GET /api/app/users/show" do
    context "login" do
      before { login }
      let(:body) { response.body }
      it "return detail of user" do
        is_expected.to eq 200
        expect(body).to have_json_path("id")
        expect(body).to have_json_path("username")
        expect(body).to have_json_path("email")
        expect(body).to have_json_path("photos")
        expect(body).to have_json_type(Array).at_path("photos")
      end
    end

    context "not login" do
      let(:body) { response.body }
      it "return not authorized" do
        is_expected.to eq 401
      end
    end
  end

  describe "PATCH /api/app/users/photo" do
    let(:params) {{photos: [-1]}}
    let(:body) { response.body }

    context "login" do
      before do
        login
        @photo = FactoryGirl.create(:bus_stop_photo_with_photo, user: @user)
      end
      it "remove photo" do
        is_expected.to eq 200
        expect(@user.bus_stop_photos.size).to eq 0
      end
    end

    context "not login" do
      it "return not authorized" do
        is_expected.to eq 401
      end
    end
  end
end
