# frozen_string_literal: true

FactoryBot.define do
  factory :publication_type do
    sequence(:name) { |n| "Publication Type #{n}" }
  end
end
