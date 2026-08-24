# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByPublicationType) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are readings" do
      let!(:hq) { create(:publication_type, name: "HQ") }
      let!(:manga) { create(:publication_type, name: "Manga") }
      let!(:comic_hq_a) { create(:comic, publication_type: hq) }
      let!(:comic_hq_b) { create(:comic, publication_type: hq) }
      let!(:comic_manga) { create(:comic, publication_type: manga) }

      before do
        create(:reading, comic: comic_hq_a, read_at: Date.new(2022, 5, 10))
        create(:reading, comic: comic_hq_b, read_at: Date.new(2023, 8, 3))
        create(:reading, comic: comic_manga, read_at: Date.new(2023, 1, 20))
      end

      it "returns publication types with readings ordered by count descending" do
        expect(context.read_comics_publication_types).to(eq(["HQ", "Manga"]))
      end

      it "returns reading counts per publication type respecting publication type order" do
        expect(context.read_comics_count_by_publication_type).to(eq([2, 1]))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are no readings" do
      it "returns an empty list of publication types with readings" do
        expect(context.read_comics_publication_types).to(eq([]))
      end

      it "returns an empty list of reading counts per publication type" do
        expect(context.read_comics_count_by_publication_type).to(eq([]))
      end
    end
  end
end
