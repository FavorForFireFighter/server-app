require 'rails_helper'

RSpec.describe SessionController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template :index
    end

    it "has user" do
      get :index
      expect(assigns[:user]).to be_truthy
    end
  end

  describe "POST #login" do
    before do
      @user = FactoryGirl.create(:user)
      @valid_params = {username: @user.username, password: @user.password}
      @invalid_params = {username: @user.username, password: "invalid"}
    end
    context "with valid params" do
      it "success to login" do
        post :login, user: @valid_params
        redirect_to root_path
        expect(session[:id]).to eq @user.id
      end
    end
    context "with invalid params" do
      it "faild to login" do
        post :login, user: @invalid_params
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #logout" do
    it "returns http success" do
      get :logout
      redirect_to root_path
    end
  end

end
