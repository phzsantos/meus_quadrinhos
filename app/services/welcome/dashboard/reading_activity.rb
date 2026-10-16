# frozen_string_literal: true

module Welcome
  module Dashboard
    class ReadingActivity
      include Interactor
      include UserScopedReadings

      MIN_LABEL_GAP = 3

      def call
        today = Time.zone.today
        grid_start = week_start(today - 1.year + 1.day)
        counts = counts_by_date(grid_start, today)
        weeks = weeks_for(grid_start, today, counts)

        context.reading_activity_weeks = weeks
        context.reading_activity_months = month_columns(weeks)
        context.reading_activity_total = counts.values.sum
      end

      private

      def week_start(date)
        date - date.wday
      end

      def counts_by_date(grid_start, today)
        readings_scope
          .where(read_at: grid_start..today)
          .group(:read_at)
          .count
          .each_with_object({}) do |(date, count), grouped|
            grouped[date.to_date] = count
          end
      end

      def weeks_for(grid_start, today, counts)
        weeks = []
        date = grid_start

        while date <= today
          weeks << week_for(date, today, counts)
          date += 7
        end

        weeks
      end

      def week_for(sunday, today, counts)
        (0..6).map do |offset|
          day = sunday + offset
          next if day > today

          { date: day, count: counts[day] || 0 }
        end
      end

      def month_columns(weeks)
        columns = Array.new(weeks.size)
        previous_index = -MIN_LABEL_GAP

        weeks.each_with_index do |days, index|
          month = month_starting_in(days)
          next if month.nil?
          next if index - previous_index < MIN_LABEL_GAP

          columns[index] = month
          previous_index = index
        end

        label_opening_month(columns, weeks)
      end

      def month_starting_in(days)
        match = days.compact.find { |day| day[:date].day == 1 }
        match&.dig(:date)&.month
      end

      def label_opening_month(columns, weeks)
        next_label = columns.index { |month| month }
        return columns if next_label&.zero?
        return columns if next_label && next_label < 2

        opening = weeks.first&.compact&.first
        columns[0] = opening[:date].month if opening
        columns
      end
    end
  end
end
