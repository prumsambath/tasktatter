require 'faker'

FactoryGirl.define do
  factory :list do
    title Faker::Lorem.words.join(' ')
  end
end
