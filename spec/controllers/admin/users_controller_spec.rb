require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin)
  end
  let(:login) { session[:id] = @admin.id }

  describe "GET #index" do
    before { login }
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "render index template" do
      get :index
      expect(response).to render_template :index
      expect(assigns[:users]).to match_array [@user, @admin]
    end
  end

  describe "GET #show" do
    before { login }
    it "returns http success" do
      get :show, id: @admin.id
      expect(response).to have_http_status(:success)
    end
    it "render show template" do
      get :show, id: @admin.id
      expect(response).to render_template :show
      expect(assigns[:user]).to eq @admin
    end
  end

  describe "GET #edit" do
    before { login }
    it "returns http success" do
      get :edit, id: @user.id
      expect(response).to have_http_status(:success)
    end
    it "render edit template" do
      get :edit, id: @user.id
      expect(response).to render_template :edit
      expect(assigns[:user]).to eq @user
    end
  end

  describe "GET #update" do
    before do
      login
      @valid_params = {email: Faker::Internet.email, admin_flag: true}
      @invalid_params = {email: "Invalid"}
    end
    it "redirect to #show" do
      patch :update, id: @user.id, user: @valid_params
      expect(response).to redirect_to admin_user_path(@user.id)
    end
    it "update attribute" do
      patch :update, id: @user.id, user: @valid_params
      expect(@user.reload.email).to eq @valid_params[:email]
      expect(@user.reload.admin_flag).to eq @valid_params[:admin_flag]
    end
    context "with new password" do
      it "authorized new password" do
        password = Faker::Internet.password(8)+"a1"
        @valid_params.merge!({password: password, password_confirmation: password})
        patch :update, id: @user.id, user: @valid_params
        expect(@user.reload.authenticate(password)).to be_truthy
      end
    end

    context "invalid pattern" do
      it "render edit template" do
        patch :update, id: @user.id, user: @invalid_params
        expect(response).to render_template :edit
        expect(assigns[:user].errors).to be_truthy
      end
    end
  end

  describe "GET #destroy" do
    before { login }
    it "redirect to #index" do
      get :destroy, id: @user.id
      expect(response).to redirect_to admin_users_path
      expect(flash[:notice]).to be_present
    end
    it "delete user" do
      get :destroy, id: @user.id
      expect(User.find_by(id: @user.id)).to be_falsey
    end
    context "when admin delete yourself" do
      it "redirect to logout" do
        get :destroy, id: @admin.id
        expect(response).to redirect_to session_logout_path
      end
    end
  end

  describe "GET #photos_index" do
    before do
      session[:id] = @admin.id
    end
    it "returns http success" do
      get :photos_index, id: @admin.id
      expect(response).to have_http_status(:success)
    end
    it "render photos template" do
      get :photos_index, id: @admin.id
      expect(response).to render_template :photos_index
      expect(assigns[:bus_stop_photos]).to be_truthy
    end
  end

end
