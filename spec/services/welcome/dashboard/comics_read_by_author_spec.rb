# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByAuthor) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are readings" do
      let!(:miller) { create(:author, name: "Frank Miller") }
      let!(:moore) { create(:author, name: "Alan Moore") }
      let!(:comic_miller) do
        create(:comic, authors: [miller])
      end
      let!(:comic_team) do
        create(:comic, authors: [miller, moore])
      end

      before do
        create(:reading, comic: comic_miller, read_at: Date.new(2022, 5, 10))
        create(:reading, comic: comic_team, read_at: Date.new(2023, 8, 3))
        create(:reading, comic: comic_miller, read_at: Date.new(2023, 1, 20))
      end

      it "returns authors with readings ordered by count descending" do
        expect(context.read_comics_authors).to(eq(["Frank Miller", "Alan Moore"]))
      end

      it "returns reading counts per author respecting author order" do
        expect(context.read_comics_count_by_author).to(eq([3, 1]))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are more than seven authors with readings" do
      before do
        8.times do |index|
          author = create(:author, name: "Author #{index}")
          comic = create(:comic, authors: [author])

          (8 - index).times do
            create(:reading, comic: comic, read_at: Date.new(2023, 1, index + 1))
          end
        end
      end

      it "returns only the top seven authors" do
        expect(context.read_comics_authors.size).to(eq(7))
      end

      it "returns the seven most read authors in descending order" do
        expect(context.read_comics_authors).to(eq(
          [
            "Author 0",
            "Author 1",
            "Author 2",
            "Author 3",
            "Author 4",
            "Author 5",
            "Author 6",
          ],
        ))
      end

      it "returns reading counts for the top seven authors" do
        expect(context.read_comics_count_by_author).to(eq([8, 7, 6, 5, 4, 3, 2]))
      end
    end

    context "when there are no readings" do
      it "returns an empty list of authors with readings" do
        expect(context.read_comics_authors).to(eq([]))
      end

      it "returns an empty list of reading counts per author" do
        expect(context.read_comics_count_by_author).to(eq([]))
      end
    end
  end
end
