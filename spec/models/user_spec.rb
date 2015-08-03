require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryGirl.build(:user)
  end

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:admin_flag) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:authenticate) }
  it { should be_valid }

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(username: @user.username) }

    context "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    context "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_falsey }
    end
  end
end
