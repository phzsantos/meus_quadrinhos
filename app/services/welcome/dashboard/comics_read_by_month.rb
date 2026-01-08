# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByMonth
      include Interactor

      def call
        grouped = Reading
          .where.not(read_at: nil)
          .group_by { |r| r.read_at.beginning_of_month }

        months = grouped.keys.sort

        context.read_comics_months = months
        context.read_comics_count_by_month =
          months.map { |month| grouped[month].count }
      end
    end
  end
end
