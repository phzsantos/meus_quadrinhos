# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByCharacter) do
  let(:user) { create(:user) }

  subject(:context) { described_class.call(user: user) }

  describe ".call" do
    context "when there are readings" do
      let!(:wolverine) { create(:character, name: "Wolverine") }
      let!(:cyclops) { create(:character, name: "Cyclops") }
      let!(:comic_wolverine) do
        create(:comic, characters: [wolverine])
      end
      let!(:comic_team) do
        create(:comic, characters: [wolverine, cyclops])
      end

      before do
        create(:reading, user: user, comic: comic_wolverine, read_at: Date.new(2022, 5, 10))
        create(:reading, user: user, comic: comic_team, read_at: Date.new(2023, 8, 3))
        create(:reading, user: user, comic: comic_wolverine, read_at: Date.new(2023, 1, 20))
      end

      it "returns characters with readings ordered by count descending" do
        expect(context.read_comics_characters).to(eq(["Wolverine", "Cyclops"]))
      end

      it "returns reading counts per character respecting character order" do
        expect(context.read_comics_count_by_character).to(eq([3, 1]))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are more than seven characters with readings" do
      before do
        8.times do |index|
          character = create(:character, name: "Character #{index}")
          comic = create(:comic, characters: [character])

          (8 - index).times do
            create(:reading, user: user, comic: comic, read_at: Date.new(2023, 1, index + 1))
          end
        end
      end

      it "returns only the top seven characters" do
        expect(context.read_comics_characters.size).to(eq(7))
      end

      it "returns the seven most read characters in descending order" do
        expect(context.read_comics_characters).to(eq(
          [
            "Character 0",
            "Character 1",
            "Character 2",
            "Character 3",
            "Character 4",
            "Character 5",
            "Character 6",
          ],
        ))
      end

      it "returns reading counts for the top seven characters" do
        expect(context.read_comics_count_by_character).to(eq([8, 7, 6, 5, 4, 3, 2]))
      end
    end

    context "when there are no readings" do
      it "returns an empty list of characters with readings" do
        expect(context.read_comics_characters).to(eq([]))
      end

      it "returns an empty list of reading counts per character" do
        expect(context.read_comics_count_by_character).to(eq([]))
      end
    end
  end
end
