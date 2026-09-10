# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByPublisher
      include Interactor
      include UserScopedReadings

      def call
        grouped = readings_scope
          .includes(comic: :publisher)
          .where.not(read_at: nil)
          .group_by { |r| r.comic.publisher.name }

        publishers = grouped
          .sort_by { |name, readings| [-readings.count, name] }
          .map(&:first)

        context.read_comics_publishers = publishers
        context.read_comics_count_by_publisher =
          publishers.map { |publisher| grouped[publisher].count }
      end
    end
  end
end
