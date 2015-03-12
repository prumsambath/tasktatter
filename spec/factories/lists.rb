require 'faker'

FactoryGirl.define do
  factory :list do
    title Faker::Lorem.words.join(' ')
    permission :private
  end
end
