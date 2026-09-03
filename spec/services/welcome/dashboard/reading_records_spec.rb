# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ReadingRecords) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are readings in different months" do
      let!(:comic_jan) { create(:comic, story_count: 2, page_count: 50) }
      let!(:comic_jan_2) { create(:comic, story_count: 1, page_count: 50) }
      let!(:comic_feb) { create(:comic, story_count: 5, page_count: 200) }

      before do
        create(:reading, comic: comic_jan,   read_at: Date.new(2023, 1, 5))
        create(:reading, comic: comic_jan_2, read_at: Date.new(2023, 1, 20))
        create(:reading, comic: comic_feb,   read_at: Date.new(2023, 2, 10))
      end

      it "returns the month with the most comics read" do
        expect(context.best_month).to(eq(Date.new(2023, 1, 1)))
      end

      it "returns the count of comics read in the best month" do
        expect(context.best_month_comics_count).to(eq(2))
      end

      it "returns the month with the most stories read" do
        expect(context.best_stories_month).to(eq(Date.new(2023, 2, 1)))
      end

      it "returns the count of stories read in the best stories month" do
        expect(context.best_month_stories_count).to(eq(5))
      end

      it "returns the month with the most pages read" do
        expect(context.best_pages_month).to(eq(Date.new(2023, 2, 1)))
      end

      it "returns the count of pages read in the best pages month" do
        expect(context.best_month_pages_count).to(eq(200))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when two months have the same count" do
      before do
        create(:reading, read_at: Date.new(2023, 1, 5))
        create(:reading, read_at: Date.new(2023, 2, 10))
      end

      it "returns the most recent month as the comics record" do
        expect(context.best_month).to(eq(Date.new(2023, 2, 1)))
      end

      it "returns the most recent month as the stories record" do
        expect(context.best_stories_month).to(eq(Date.new(2023, 2, 1)))
      end

      it "returns the most recent month as the pages record" do
        expect(context.best_pages_month).to(eq(Date.new(2023, 2, 1)))
      end
    end

    context "when there are no readings" do
      it "returns zero comics count" do
        expect(context.best_month_comics_count).to(eq(0))
      end

      it "returns no best comics month" do
        expect(context.best_month).to(be_nil)
      end

      it "returns zero stories count" do
        expect(context.best_month_stories_count).to(eq(0))
      end

      it "returns no best stories month" do
        expect(context.best_stories_month).to(be_nil)
      end

      it "returns zero pages count" do
        expect(context.best_month_pages_count).to(eq(0))
      end

      it "returns no best pages month" do
        expect(context.best_pages_month).to(be_nil)
      end
    end
  end
end
