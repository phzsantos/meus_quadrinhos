# frozen_string_literal: true

module CatalogVisibility
  extend ActiveSupport::Concern

  class_methods do
    def with_comics_visible_to(user)
      where(id: joins(:comics).merge(Comic.visible_to(user)).select(arel_table[:id]))
    end
  end
end
