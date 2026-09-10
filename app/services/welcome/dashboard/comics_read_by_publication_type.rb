# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByPublicationType
      include Interactor
      include UserScopedReadings

      def call
        grouped = readings_scope
          .includes(comic: :publication_type)
          .where.not(read_at: nil)
          .group_by { |r| r.comic.publication_type.name }

        publication_types = grouped
          .sort_by { |name, readings| [-readings.count, name] }
          .map(&:first)

        context.read_comics_publication_types = publication_types
        context.read_comics_count_by_publication_type =
          publication_types.map { |publication_type| grouped[publication_type].count }
      end
    end
  end
end
