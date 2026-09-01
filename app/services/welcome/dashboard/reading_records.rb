# frozen_string_literal: true

module Welcome
  module Dashboard
    class ReadingRecords
      include Interactor

      def call
        grouped = Reading
          .where.not(read_at: nil)
          .group_by { |reading| reading.read_at.beginning_of_month }

        best_month, readings = grouped.max_by { |month, month_readings| [month_readings.size, month] }

        context.best_month_comics_count = readings&.size || 0
        context.best_month = best_month
      end
    end
  end
end
