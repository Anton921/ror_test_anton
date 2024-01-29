# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { Faker::App.name }
    description { Faker::Lorem.sentence }
    status { Task.statuses.keys.sample }
    project
  end
end
