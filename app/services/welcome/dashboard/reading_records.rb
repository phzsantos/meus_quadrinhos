# frozen_string_literal: true

module Welcome
  module Dashboard
    class ReadingRecords
      include Interactor
      include UserScopedReadings

      def call
        comics_by_month = readings_scope
          .where.not(read_at: nil)
          .group_by { |r| r.read_at.beginning_of_month }
          .transform_values(&:count)

        best_comics_month, best_comics_count = comics_by_month.max_by { |month, count| [count, month] }

        context.best_month = best_comics_month
        context.best_month_comics_count = best_comics_count || 0

        stories_by_month = readings_scope
          .includes(:comic)
          .where.not(read_at: nil)
          .group_by { |r| r.read_at.beginning_of_month }
          .transform_values { |readings| readings.sum { |r| r.comic.story_count.to_i } }

        best_stories_month, best_stories_count = stories_by_month.max_by { |month, count| [count, month] }

        context.best_stories_month = best_stories_month
        context.best_month_stories_count = best_stories_count || 0

        pages_by_month = readings_scope
          .includes(:comic)
          .where.not(read_at: nil)
          .group_by { |r| r.read_at.beginning_of_month }
          .transform_values { |readings| readings.sum { |r| r.comic.page_count.to_i } }

        best_pages_month, best_pages_count = pages_by_month.max_by { |month, count| [count, month] }

        context.best_pages_month = best_pages_month
        context.best_month_pages_count = best_pages_count || 0

        reading_days = readings_scope
          .where.not(read_at: nil)
          .distinct
          .order(:read_at)
          .pluck(:read_at)

        longest_streak = reading_days
          .slice_when { |previous_day, current_day| current_day != previous_day + 1 }
          .max_by { |streak| [streak.size, streak.last] }

        context.longest_reading_streak_days = longest_streak&.size || 0
        context.longest_reading_streak_start = longest_streak&.first
        context.longest_reading_streak_end = longest_streak&.last
      end
    end
  end
end
