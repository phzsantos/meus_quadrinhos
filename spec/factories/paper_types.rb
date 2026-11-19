# frozen_string_literal: true

FactoryBot.define do
  factory :paper_type do
    sequence(:name) { |n| "Paper Type #{n}" }
  end
end
