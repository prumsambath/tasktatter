require 'faker'

FactoryGirl.define do
  factory :task do
    title Faker::Lorem.words.join(' ')
    list
  end
end
