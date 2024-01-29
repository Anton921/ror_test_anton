# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'valid@example.com' }
    password { 'password' }
    jti { SecureRandom.uuid }
  end
end
