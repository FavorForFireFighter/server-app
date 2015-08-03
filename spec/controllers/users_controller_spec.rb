require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, id: @user.id
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
    it "render new template" do
      get :new
      expect(assigns[:user]).to be_a_new(User)
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before do
      password = Faker::Internet.password(8)+"a1"
      @valid_params = {username: Faker::Internet.user_name, email: Faker::Internet.email, password: password, password_confirmation: password}
      @invalid_params = {username: Faker::Internet.user_name, email: Faker::Internet.email, password: password, password_confirmation: "invalid"}
    end
    context "with valid params" do
      it "redirect to #show" do
        post :create, user: @valid_params
        user = User.find_by(username: @valid_params[:username])
        expect(response).to redirect_to(action: 'show', id: user.id)
      end
      it "create account" do
        post :create, user: @valid_params
        expect(session[:id]).to be_truthy
        expect(User.find_by(username: @valid_params[:username])).to be_truthy
      end
    end
    context "with invalid params" do
      it "render new template" do
        post :create, user: @invalid_params
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, id: @user.id
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    it "returns http success" do
      put :update, id: @user.id
      expect(response).to redirect_to root_path
    end
  end

  describe "GET #photos" do
    it "returns http success" do
      get :photos, id: @user.id
      expect(response).to have_http_status(:success)
    end
  end

end
