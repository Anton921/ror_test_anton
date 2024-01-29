# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::App.name }
    description { Faker::Lorem.sentence }

    trait :with_tasks do
      after(:create) do |project|
        create_list(:task, 3, project:)
      end
    end
  end
end
