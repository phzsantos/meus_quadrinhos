# frozen_string_literal: true

FactoryBot.define do
  factory :reading do
    read_at { Date.today }
    comic
  end
end
