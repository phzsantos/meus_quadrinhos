# frozen_string_literal: true

module Welcome
  module Dashboard
    class PagesReadByMonth
      include Interactor

      def call
        scope = Reading.includes(:comic).where.not(read_at: nil)

        if context.start_date.present?
          scope = scope.where(read_at: context.start_date..context.end_date)
        end

        grouped = scope.to_a.group_by { |r| r.read_at.beginning_of_month }

        months = grouped.keys.sort

        context.pages_read_months = months
        context.pages_read_count_by_month =
          months.map do |month|
            grouped[month].sum { |r| r.comic.page_count.to_i }
          end
      end
    end
  end
end
