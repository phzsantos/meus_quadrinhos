# frozen_string_literal: true

module Welcome
  module Dashboard
    class PagesReadByYear
      include Interactor
      include UserScopedReadings

      def call
        grouped = readings_scope
          .includes(:comic)
          .where.not(read_at: nil)
          .group_by { |r| r.read_at.year }

        years = grouped.keys.sort

        context.pages_read_years = years
        context.pages_read_count_by_year =
          years.map do |year|
            grouped[year].sum { |r| r.comic.page_count.to_i }
          end
      end
    end
  end
end
