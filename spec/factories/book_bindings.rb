# frozen_string_literal: true

FactoryBot.define do
  factory :book_binding do
    sequence(:name) { |n| "Book Binding #{n}" }
  end
end
