# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByBookBinding
      include Interactor
      include UserScopedReadings

      LIMIT = 7

      def call
        counts = Hash.new(0)

        readings_scope
          .includes(comic: :book_binding)
          .where.not(read_at: nil)
          .find_each do |reading|
            counts[reading.comic.book_binding.name] += 1
          end

        ranked = counts.sort_by { |name, count| [-count, name] }.first(LIMIT)

        context.read_comics_book_bindings = ranked.map(&:first)
        context.read_comics_count_by_book_binding = ranked.map(&:last)
      end
    end
  end
end
