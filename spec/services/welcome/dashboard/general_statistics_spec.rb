# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::GeneralStatistics) do
  include ActiveSupport::Testing::TimeHelpers

  subject(:context) { described_class.call }

  describe ".call" do
    around do |example|
      travel_to(Time.zone.local(2024, 3, 15, 12, 0, 0)) { example.run }
    end

    context "when there are readings in different periods" do
      let!(:comic_a) { create(:comic, page_count: 100, story_count: 2) }
      let!(:comic_b) { create(:comic, page_count: 200, story_count: 3) }

      before do
        # reading in the current month
        create(:reading, comic: comic_a, read_at: Time.current.beginning_of_month + 1.day)

        # reading outside the current month
        create(:reading, comic: comic_b, read_at: 2.months.ago)
      end

      it "returns the total number of comics read" do
        expect(context.total_comics_read).to(eq(2))
      end

      it "returns the total number of stories read" do
        expect(context.total_story_count).to(eq(5))
      end

      it "returns the total number of pages read" do
        expect(context.total_pages_read).to(eq(300))
      end

      it "returns the number of comics read in the current month" do
        expect(context.comics_read_this_month).to(eq(1))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are no readings" do
      it "returns 0 for total comics read" do
        expect(context.total_comics_read).to(eq(0))
      end

      it "returns 0 for total stories read" do
        expect(context.total_story_count).to(eq(0))
      end

      it "returns 0 for total pages read" do
        expect(context.total_pages_read).to(eq(0))
      end

      it "returns 0 for comics read this month" do
        expect(context.comics_read_this_month).to(eq(0))
      end
    end
  end
end
