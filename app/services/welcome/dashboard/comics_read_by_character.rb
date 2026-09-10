# frozen_string_literal: true

module Welcome
  module Dashboard
    class ComicsReadByCharacter
      include Interactor
      include UserScopedReadings

      LIMIT = 7

      def call
        counts = Hash.new(0)

        readings_scope
          .includes(comic: :characters)
          .where.not(read_at: nil)
          .find_each do |reading|
            reading.comic.characters.each do |character|
              counts[character.name] += 1
            end
          end

        ranked = counts.sort_by { |name, count| [-count, name] }.first(LIMIT)

        context.read_comics_characters = ranked.map(&:first)
        context.read_comics_count_by_character = ranked.map(&:last)
      end
    end
  end
end
