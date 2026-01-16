# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    name { Faker::Book.title }
  end
end
