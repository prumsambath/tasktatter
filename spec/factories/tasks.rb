require 'faker'

FactoryGirl.define do
  factory :task do
    title Faker::Lorem.words.join(' ')
    completed false
    list
  end
end
