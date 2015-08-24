FactoryGirl.define do
  factory :user do
    email {Faker::Internet.email}
    password {Faker::Internet.password(8)+"a1"}
    username {Faker::Internet.user_name}
    admin_flag false

    factory :admin do
      admin_flag true
    end
  end

end
