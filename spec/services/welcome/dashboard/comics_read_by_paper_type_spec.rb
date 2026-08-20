# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByPaperType) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are readings" do
      let!(:offset) { create(:paper_type, name: "Offset") }
      let!(:couche) { create(:paper_type, name: "Couchê") }
      let!(:comic_offset_a) { create(:comic, paper_type: offset) }
      let!(:comic_offset_b) { create(:comic, paper_type: offset) }
      let!(:comic_couche) { create(:comic, paper_type: couche) }

      before do
        create(:reading, comic: comic_offset_a, read_at: Date.new(2022, 5, 10))
        create(:reading, comic: comic_offset_b, read_at: Date.new(2023, 8, 3))
        create(:reading, comic: comic_couche, read_at: Date.new(2023, 1, 20))
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
