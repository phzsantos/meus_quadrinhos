# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByYear
      include Interactor
      include UserScopedReadings

      def call
        grouped = readings_scope
          .where.not(read_at: nil)
          .group_by { |r| r.read_at.year }

        years = grouped.keys.sort

        context.read_comics_years = years
        context.read_comics_count_by_year =
          years.map { |year| grouped[year].count }
      end
    end
  end
end
