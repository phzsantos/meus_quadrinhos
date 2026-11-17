# frozen_string_literal: true

module CatalogVisibility
  extend ActiveSupport::Concern

  class_methods do
    def with_comics_visible_to(user)
      return all if user&.admin?

      where(id: joins(:comics).merge(Comic.visible_to(user)).select(arel_table[:id]))
    end

    def with_visible_comics_count(user)
      association = reflect_on_association(:comics)
      count_scope = Comic.visible_to(user)

      if association.through_reflection
        through = association.through_reflection
        join_table = through.klass.arel_table
        count_scope = count_scope
          .joins(through.name)
          .where(join_table[through.foreign_key].eq(arel_table[:id]))
      else
        count_scope = count_scope
          .where(Comic.arel_table[association.foreign_key].eq(arel_table[:id]))
      end

      select(
        "#{table_name}.*",
        Arel.sql("(#{count_scope.select("COUNT(*)").to_sql}) AS visible_comics_count"),
      )
    end
  end
end
