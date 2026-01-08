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
      end
    end
  end
end
