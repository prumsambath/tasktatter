FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'helloworld'
    password_confirmation 'helloworld'
  end
end
