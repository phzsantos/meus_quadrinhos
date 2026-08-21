# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByAuthor
      include Interactor

      LIMIT = 7

      def call
        counts = Hash.new(0)

        Reading
          .includes(comic: :authors)
          .where.not(read_at: nil)
          .find_each do |reading|
            reading.comic.authors.each do |author|
              counts[author.name] += 1
            end
          end

        ranked = counts.sort_by { |name, count| [-count, name] }.first(LIMIT)

        context.read_comics_authors = ranked.map(&:first)
        context.read_comics_count_by_author = ranked.map(&:last)
      end
    end
  end
end
