# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    name { Faker::Book.unique.title }
  end
end
