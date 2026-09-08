# frozen_string_literal: true

module Welcome
  module Dashboard
    class GeneralStatistics
      include Interactor

      def call
        context.total_comics_read = Reading.where.not(read_at: nil).count

        context.total_story_count = Reading
          .includes(:comic)
          .where.not(read_at: nil)
          .sum { |r| r.comic.story_count.to_i }

        context.total_pages_read = Reading
          .includes(:comic)
          .where.not(read_at: nil)
          .sum { |r| r.comic.page_count.to_i }

        context.comics_read_this_month = Reading
          .where.not(read_at: nil)
          .where(read_at: Time.current.beginning_of_month..Time.current.end_of_month)
          .count

        reading_days = Reading
          .where.not(read_at: nil)
          .distinct
          .order(:read_at)
          .pluck(:read_at)

        current_streak = reading_days
          .slice_when { |previous_day, current_day| current_day != previous_day + 1 }
          .to_a
          .last

        context.current_reading_streak_days =
          if current_streak.present? && current_streak.last >= Time.zone.today - 1.day
            current_streak.size
          else
            0
          end
      end
    end
  end
end
