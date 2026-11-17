# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByPaperType) do
  let(:user) { create(:user) }

  subject(:context) { described_class.call(user: user) }

  describe ".call" do
    context "when there are readings" do
      let!(:offset) { create(:paper_type, name: "Offset") }
      let!(:couche) { create(:paper_type, name: "Couchê") }
      let!(:comic_offset_a) { create(:comic, paper_type: offset) }
      let!(:comic_offset_b) { create(:comic, paper_type: offset) }
      let!(:comic_couche) { create(:comic, paper_type: couche) }

      before do
        create(:reading, user: user, comic: comic_offset_a, read_at: Date.new(2022, 5, 10))
        create(:reading, user: user, comic: comic_offset_b, read_at: Date.new(2023, 8, 3))
        create(:reading, user: user, comic: comic_couche, read_at: Date.new(2023, 1, 20))
      end

      it "returns paper types with readings ordered by count descending" do
        expect(context.read_comics_paper_types).to(eq(["Offset", "Couchê"]))
      end

      it "returns reading counts per paper type respecting paper type order" do
        expect(context.read_comics_count_by_paper_type).to(eq([2, 1]))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are more than seven paper types with readings" do
      before do
        8.times do |index|
          paper_type = create(:paper_type, name: "Paper #{index}")
          comic = create(:comic, paper_type: paper_type)

          (8 - index).times do
            create(:reading, user: user, comic: comic, read_at: Date.new(2023, 1, index + 1))
          end
        end
      end

      it "returns only the top seven paper types" do
        expect(context.read_comics_paper_types.size).to(eq(7))
      end

      it "returns the seven most read paper types in descending order" do
        expect(context.read_comics_paper_types).to(eq(
          [
            "Paper 0",
            "Paper 1",
            "Paper 2",
            "Paper 3",
            "Paper 4",
            "Paper 5",
            "Paper 6",
          ],
        ))
      end

      it "returns reading counts for the top seven paper types" do
        expect(context.read_comics_count_by_paper_type).to(eq([8, 7, 6, 5, 4, 3, 2]))
      end
    end

    context "when there are no readings" do
      it "returns an empty list of paper types with readings" do
        expect(context.read_comics_paper_types).to(eq([]))
      end

      it "returns an empty list of reading counts per paper type" do
        expect(context.read_comics_count_by_paper_type).to(eq([]))
      end
    end
  end
end
