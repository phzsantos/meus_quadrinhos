# frozen_string_literal: true

FactoryBot.define do
  factory :book_binding do
    name { Faker::Commerce.material }
  end
end
