# frozen_string_literal: true

FactoryBot.define do
  factory :reading do
    read_at { Time.zone.today }
    comic
  end
end
