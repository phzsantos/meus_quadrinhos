# frozen_string_literal: true

FactoryBot.define do
  factory :publication_type do
    name { Faker::Book.genre }
  end
end
