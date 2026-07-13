# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::StoriesReadByMonth) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are readings in different months" do
      let!(:comic_jan) { create(:comic, story_count: 2) }
      let!(:comic_jan_2) { create(:comic, story_count: 3) }
      let!(:comic_feb) { create(:comic, story_count: 4) }

      before do
        create(:reading, comic: comic_jan,   read_at: Date.new(2023, 1, 5))
        create(:reading, comic: comic_jan_2, read_at: Date.new(2023, 1, 25))
        create(:reading, comic: comic_feb,   read_at: Date.new(2023, 2, 10))
      end

      it "returns months with readings, normalized to the start of the month and in chronological order" do
        expect(context.read_stories_months).to(eq(
          [
            Date.new(2023, 1, 1),
            Date.new(2023, 2, 1),
          ],
        ))
      end

      it "returns story counts per month respecting month order" do
        expect(context.read_stories_count_by_month).to(eq([5, 4]))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when start_date is nil" do
      subject(:context) do
        described_class.call(
          start_date: nil,
          end_date: nil,
        )
      end

      let!(:comic_jan) { create(:comic, story_count: 2) }
      let!(:comic_feb) { create(:comic, story_count: 3) }

      before do
        create(:reading, comic: comic_jan, read_at: Date.new(2023, 1, 10))
        create(:reading, comic: comic_feb, read_at: Date.new(2023, 2, 10))
      end

      it "does not apply filter and returns all months" do
        expect(context.read_stories_months).to(eq(
          [
            Date.new(2023, 1, 1),
            Date.new(2023, 2, 1),
          ],
        ))
      end

      it "returns all story counts" do
        expect(context.read_stories_count_by_month).to(eq([2, 3]))
      end
    end

    context "when there is a date range filter" do
      subject(:context) do
        described_class.call(
          start_date: Date.new(2023, 2, 1),
          end_date: Date.new(2023, 2, 28),
        )
      end

      let!(:comic_jan) { create(:comic, story_count: 2) }
      let!(:comic_feb) { create(:comic, story_count: 4) }

      before do
        create(:reading, comic: comic_jan, read_at: Date.new(2023, 1, 10))
        create(:reading, comic: comic_feb, read_at: Date.new(2023, 2, 10))
      end

      it "returns only months within the given period" do
        expect(context.read_stories_months).to(eq(
          [Date.new(2023, 2, 1)],
        ))
      end

      it "returns only stories within the given period" do
        expect(context.read_stories_count_by_month).to(eq([4]))
      end
    end

    context "when there are no readings" do
      it "returns an empty list of months with readings" do
        expect(context.read_stories_months).to(eq([]))
      end

      it "returns an empty list of story counts per month" do
        expect(context.read_stories_count_by_month).to(eq([]))
      end
    end
  end
end
