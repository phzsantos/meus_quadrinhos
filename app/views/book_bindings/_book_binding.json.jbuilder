# frozen_string_literal: true

json.extract!(book_binding, :id, :name, :created_at, :updated_at)
json.url(book_binding_url(book_binding, format: :json))
