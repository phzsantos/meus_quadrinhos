# frozen_string_literal: true

FactoryBot.define do
  factory :paper_type do
    name { Faker::Commerce.material }
  end
end
