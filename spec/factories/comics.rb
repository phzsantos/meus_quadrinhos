# frozen_string_literal: true

FactoryBot.define do
  factory :comic do
    title { Faker::Book.title }
    page_count { 100 }
    published_year { 2020 }
    issue_number { 1 }
    authors { [create(:author)] }

    publisher
    publication_type
    book_binding
    paper_type
    collection
  end
end
