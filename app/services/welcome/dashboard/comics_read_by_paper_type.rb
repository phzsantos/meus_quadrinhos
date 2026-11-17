# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByPaperType
      include Interactor
      include UserScopedReadings

      LIMIT = 7

      def call
        counts = Hash.new(0)

        readings_scope
          .includes(comic: :paper_type)
          .where.not(read_at: nil)
          .find_each do |reading|
            counts[reading.comic.paper_type.name] += 1
          end

        ranked = counts.sort_by { |name, count| [-count, name] }.first(LIMIT)

        context.read_comics_paper_types = ranked.map(&:first)
        context.read_comics_count_by_paper_type = ranked.map(&:last)
      end
    end
  end
end
