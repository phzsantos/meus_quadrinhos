# frozen_string_literal: true

json.extract!(publication_type, :id, :name, :created_at, :updated_at)
json.url(publication_type_url(publication_type, format: :json))
