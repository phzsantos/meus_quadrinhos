# frozen_string_literal: true

FactoryBot.define do
  factory :character do
    name { Faker::Games::ElderScrolls.unique.name }
  end
end
