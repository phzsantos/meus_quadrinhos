# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByPublisher) do
  let(:user) { create(:user) }

  subject(:context) { described_class.call(user: user) }

  describe ".call" do
    context "when there are readings" do
      let!(:panini) { create(:publisher, name: "Panini") }
      let!(:abril) { create(:publisher, name: "Abril") }
      let!(:comic_panini_a) { create(:comic, publisher: panini) }
      let!(:comic_panini_b) { create(:comic, publisher: panini) }
      let!(:comic_abril) { create(:comic, publisher: abril) }

      before do
        create(:reading, user: user, comic: comic_panini_a, read_at: Date.new(2022, 5, 10))
        create(:reading, user: user, comic: comic_panini_b, read_at: Date.new(2023, 8, 3))
        create(:reading, user: user, comic: comic_abril, read_at: Date.new(2023, 1, 20))
      end

      it "returns publishers with readings ordered by count descending" do
        expect(context.read_comics_publishers).to(eq(["Panini", "Abril"]))
      end

      it "returns reading counts per publisher respecting publisher order" do
        expect(context.read_comics_count_by_publisher).to(eq([2, 1]))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are no readings" do
      it "returns an empty list of publishers with readings" do
        expect(context.read_comics_publishers).to(eq([]))
      end

      it "returns an empty list of reading counts per publisher" do
        expect(context.read_comics_count_by_publisher).to(eq([]))
      end
    end
  end
end
