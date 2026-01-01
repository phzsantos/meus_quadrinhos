# frozen_string_literal: true

json.extract!(paper_type, :id, :name, :created_at, :updated_at)
json.url(paper_type_url(paper_type, format: :json))
