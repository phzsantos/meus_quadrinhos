# frozen_string_literal: true

module NameSearch
  extend ActiveSupport::Concern

  included do
    scope :matching_query, lambda { |query|
      ::CatalogSearch.filter(all, query, arel_table[:name])
    }
  end
end
