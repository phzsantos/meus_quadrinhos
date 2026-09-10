# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByPaperType
      include Interactor
      include UserScopedReadings

      def call
        grouped = readings_scope
          .includes(comic: :paper_type)
          .where.not(read_at: nil)
          .group_by { |r| r.comic.paper_type.name }

        paper_types = grouped
          .sort_by { |name, readings| [-readings.count, name] }
          .map(&:first)

        context.read_comics_paper_types = paper_types
        context.read_comics_count_by_paper_type =
          paper_types.map { |paper_type| grouped[paper_type].count }
      end
    end
  end
end
