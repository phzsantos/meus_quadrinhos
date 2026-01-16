# frozen_string_literal: true

FactoryBot.define do
  factory :comic_author do
    comic
    author
  end
end
