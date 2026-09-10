# frozen_string_literal: true

module Welcome
  module Dashboard
    class GeneralStatistics
      include Interactor
      include UserScopedReadings

      def call
        context.total_comics_read = readings_scope.where.not(read_at: nil).count

        context.total_story_count = readings_scope
          .includes(:comic)
          .where.not(read_at: nil)
          .sum { |r| r.comic.story_count.to_i }

        context.total_pages_read = readings_scope
          .includes(:comic)
          .where.not(read_at: nil)
          .sum { |r| r.comic.page_count.to_i }

        context.comics_read_this_month = readings_scope
          .where.not(read_at: nil)
          .where(read_at: Time.current.beginning_of_month..Time.current.end_of_month)
          .count

        reading_days = readings_scope
          .where.not(read_at: nil)
          .pluck(:read_at)
          .map(&:to_date)
          .to_set

        today = Time.zone.today
        streak_days = 0
        day = today

        while reading_days.include?(day)
          streak_days += 1
          day -= 1.day
        end

        context.current_reading_streak_days = streak_days
      end
    end
  end
end
