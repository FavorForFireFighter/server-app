require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "before_action" do
    describe "user not login" do
      it "redirect to login page" do
        get :show, id: @user.id
        expect(response).to redirect_to session_index_path
      end
    end
    describe "user access other user page" do
      it "show access denied" do
        other = FactoryGirl.create(:user)
        session[:id] = @user.id
        get :show, id: other.id
        expect(response).to render_template 'common/access_denied'
      end
    end
  end

  describe "GET #show" do
    before do
      session[:id] = @user.id
    end
    it "returns http success" do
      get :show, id: @user.id
      expect(response).to have_http_status(:success)
    end
    it "render show template" do
      get :show, id: @user.id
      expect(response).to render_template :show
      expect(assigns[:user]).to eq @user
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
    before do
      session[:id] = @user.id
    end
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

  describe "PUT #update" do
    before do
      session[:id] = @user.id
      @valid_params = {email: Faker::Internet.email}
      @invalid_params = {email: "Invalid"}
    end
    it "redirect to #show" do
      put :update, id: @user.id, current_password: @user.password, user: @valid_params
      expect(response).to redirect_to user_path(@user.id)
    end
    it "update attribute" do
      put :update, id: @user.id, current_password: @user.password, user: @valid_params
      expect(@user.reload.email).to eq @valid_params[:email]
    end
    context "with new password" do
      it "authorized new password" do
        password = Faker::Internet.password(8)+"a1"
        @valid_params.merge!({password: password, password_confirmation: password})
        put :update, id: @user.id, current_password: @user.password, user: @valid_params
        expect(@user.reload.authenticate(password)).to be_truthy
      end
    end

    context "invalid pattern" do
      it "render edit template" do
        put :update, id: @user.id, current_password: @user.password, user: @invalid_params
        expect(response).to render_template :edit
        expect(assigns[:user].errors).to be_truthy
      end
    end
  end

  describe "GET #photos" do
    before do
      session[:id] = @user.id
    end
    it "returns http success" do
      get :photos, id: @user.id
      expect(response).to have_http_status(:success)
    end
  end

end
