include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :bus_stop_photo do
    title "MyString"
    association :bus_stop, factory: :bus_stop, strategy: :build
    association :user, factory: :user, strategy: :build
    photo nil

    factory :bus_stop_photo_with_photo do
      photo { fixture_file_upload("#{Rails.root}/spec/fixtures/rails.png", "image/png") }
    end
  end

end
