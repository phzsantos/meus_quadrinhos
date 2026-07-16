# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByDayComparison
      include Interactor

      def call
        reference_date = context.reference_date || Time.current.to_date
        current_month_start = reference_date.beginning_of_month
        current_month_end = reference_date.end_of_month
        previous_month_start = (reference_date - 1.month).beginning_of_month
        previous_month_end = (reference_date - 1.month).end_of_month

        current_grouped = readings_by_day(current_month_start, current_month_end)
        previous_grouped = readings_by_day(previous_month_start, previous_month_end)

        max_day = [current_month_end.day, previous_month_end.day].max
        days = (1..max_day).to_a

        context.read_comics_comparison_days = days
        context.read_comics_count_by_day_current =
          daily_counts(days, current_grouped, current_month_end.day)
        context.read_comics_count_by_day_previous =
          daily_counts(days, previous_grouped, previous_month_end.day)
        context.read_comics_comparison_current_label = current_month_start.strftime("%m/%Y")
        context.read_comics_comparison_previous_label = previous_month_start.strftime("%m/%Y")
      end

      private

      def readings_by_day(start_date, end_date)
        Reading
          .where.not(read_at: nil)
          .where(read_at: start_date..end_date)
          .group_by { |r| r.read_at.day }
      end

      def daily_counts(days, grouped, days_in_month)
        days.map do |day|
          next 0 if day > days_in_month

          grouped[day]&.count || 0
        end
      end
    end
  end
end
