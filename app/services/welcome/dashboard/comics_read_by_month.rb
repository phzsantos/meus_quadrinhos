# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByMonth
      include Interactor

      def call
        scope = Reading.where.not(read_at: nil)

        if context.start_date.present?
          scope = scope.where(read_at: context.start_date..context.end_date)
        end

        grouped = scope.group_by { |r| r.read_at.beginning_of_month }

        months = grouped.keys.sort

        context.read_comics_months = months
        context.read_comics_count_by_month =
          months.map { |month| grouped[month].count }
      end
    end
  end
end
