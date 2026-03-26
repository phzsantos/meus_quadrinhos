# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@teste.com" }
    sequence(:username) { |n| "user#{n}" }
    password { "123456" }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
