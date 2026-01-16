# frozen_string_literal: true

FactoryBot.define do
  factory :comic_character do
    comic
    character
  end
end
