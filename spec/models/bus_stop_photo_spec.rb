require 'rails_helper'

RSpec.describe BusStopPhoto, type: :model do
  before do
    @photo = FactoryGirl.build(:bus_stop_photo)
  end

  subject { @photo }

  it { should respond_to(:photo_file_name) }
  it { should respond_to(:photo_content_type) }
  it { should respond_to(:photo_file_size) }
  it { should respond_to(:photo_updated_at) }
  it { should respond_to(:bus_stop_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:title) }
  it { should be_valid }
end
