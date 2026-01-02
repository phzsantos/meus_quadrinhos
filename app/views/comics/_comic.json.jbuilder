# frozen_string_literal: true

json.extract!(comic, :id, :title, :page_count, :published_year, :author_id, :publisher_id, :publication_type_id, :book_binding_id, :paper_type_id, :created_at, :updated_at)
json.url(comic_url(comic, format: :json))
