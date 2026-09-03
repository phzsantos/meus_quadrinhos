# frozen_string_literal: true

module Welcome
  module Dashboard
    class ReadingRecords
      include Interactor

      def call
        comics_by_month = Reading
          .where.not(read_at: nil)
          .group_by { |r| r.read_at.beginning_of_month }
          .transform_values(&:count)

        best_comics_month, best_comics_count = comics_by_month.max_by { |month, count| [count, month] }

        context.best_month = best_comics_month
        context.best_month_comics_count = best_comics_count || 0

        stories_by_month = Reading
          .includes(:comic)
          .where.not(read_at: nil)
          .group_by { |r| r.read_at.beginning_of_month }
          .transform_values { |readings| readings.sum { |r| r.comic.story_count.to_i } }

        best_stories_month, best_stories_count = stories_by_month.max_by { |month, count| [count, month] }

        context.best_stories_month = best_stories_month
        context.best_month_stories_count = best_stories_count || 0

        pages_by_month = Reading
          .includes(:comic)
          .where.not(read_at: nil)
          .group_by { |r| r.read_at.beginning_of_month }
          .transform_values { |readings| readings.sum { |r| r.comic.page_count.to_i } }

        best_pages_month, best_pages_count = pages_by_month.max_by { |month, count| [count, month] }

        context.best_pages_month = best_pages_month
        context.best_month_pages_count = best_pages_count || 0
      end
    end
  end
end
