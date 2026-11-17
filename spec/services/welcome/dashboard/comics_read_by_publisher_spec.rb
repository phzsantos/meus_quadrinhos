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

    context "when there are more than seven publishers with readings" do
      before do
        8.times do |index|
          publisher = create(:publisher, name: "Publisher #{index}")
          comic = create(:comic, publisher: publisher)

          (8 - index).times do
            create(:reading, user: user, comic: comic, read_at: Date.new(2023, 1, index + 1))
          end
        end
      end

      it "returns only the top seven publishers" do
        expect(context.read_comics_publishers.size).to(eq(7))
      end

      it "returns the seven most read publishers in descending order" do
        expect(context.read_comics_publishers).to(eq(
          [
            "Publisher 0",
            "Publisher 1",
            "Publisher 2",
            "Publisher 3",
            "Publisher 4",
            "Publisher 5",
            "Publisher 6",
          ],
        ))
      end

      it "returns reading counts for the top seven publishers" do
        expect(context.read_comics_count_by_publisher).to(eq([8, 7, 6, 5, 4, 3, 2]))
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
