# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByBookBinding
      include Interactor
      include UserScopedReadings

      def call
        grouped = readings_scope
          .includes(comic: :book_binding)
          .where.not(read_at: nil)
          .group_by { |r| r.comic.book_binding.name }

        book_bindings = grouped
          .sort_by { |name, readings| [-readings.count, name] }
          .map(&:first)

        context.read_comics_book_bindings = book_bindings
        context.read_comics_count_by_book_binding =
          book_bindings.map { |book_binding| grouped[book_binding].count }
      end
    end
  end
end
