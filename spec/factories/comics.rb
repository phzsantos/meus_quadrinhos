# frozen_string_literal: true

FactoryBot.define do
  factory :comic do
    title { Faker::Book.title }
    page_count { 100 }
    published_year { 2020 }
    issue_number { 1 }
    story_count { 1 }
    authors { [create(:author)] }
    characters { [create(:character)] }

    publisher
    publication_type
    book_binding
    paper_type
    collection
  end
end
