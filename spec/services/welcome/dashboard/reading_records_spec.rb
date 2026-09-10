# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ReadingRecords) do
  let(:user) { create(:user) }

  subject(:context) { described_class.call(user: user) }

  describe ".call" do
    context "when there are readings in different months" do
      let!(:comic_jan) { create(:comic, story_count: 2, page_count: 50) }
      let!(:comic_jan_2) { create(:comic, story_count: 1, page_count: 50) }
      let!(:comic_feb) { create(:comic, story_count: 5, page_count: 200) }

      before do
        create(:reading, user: user, comic: comic_jan,   read_at: Date.new(2023, 1, 5))
        create(:reading, user: user, comic: comic_jan_2, read_at: Date.new(2023, 1, 20))
        create(:reading, user: user, comic: comic_feb,   read_at: Date.new(2023, 2, 10))
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

    context "when there is a reading streak" do
      before do
        create(:reading, user: user, read_at: Date.new(2023, 1, 1))
        create(:reading, user: user, read_at: Date.new(2023, 1, 2))
        create(:reading, user: user, read_at: Date.new(2023, 1, 3))
        create(:reading, user: user, read_at: Date.new(2023, 1, 10))
        create(:reading, user: user, read_at: Date.new(2023, 1, 11))
      end

      it "returns the longest streak in days" do
        expect(context.longest_reading_streak_days).to(eq(3))
      end

      it "returns the start date of the longest streak" do
        expect(context.longest_reading_streak_start).to(eq(Date.new(2023, 1, 1)))
      end

      it "returns the end date of the longest streak" do
        expect(context.longest_reading_streak_end).to(eq(Date.new(2023, 1, 3)))
      end
    end

    context "when two streaks have the same length" do
      before do
        create(:reading, user: user, read_at: Date.new(2023, 1, 1))
        create(:reading, user: user, read_at: Date.new(2023, 1, 2))
        create(:reading, user: user, read_at: Date.new(2023, 2, 10))
        create(:reading, user: user, read_at: Date.new(2023, 2, 11))
      end

      it "returns the most recent streak" do
        expect(context.longest_reading_streak_start).to(eq(Date.new(2023, 2, 10)))
        expect(context.longest_reading_streak_end).to(eq(Date.new(2023, 2, 11)))
      end
    end

    context "when multiple readings happen on the same day" do
      before do
        create(:reading, user: user, read_at: Date.new(2023, 1, 1))
        create(:reading, user: user, read_at: Date.new(2023, 1, 1))
        create(:reading, user: user, read_at: Date.new(2023, 1, 2))
      end

      it "counts each day only once in the streak" do
        expect(context.longest_reading_streak_days).to(eq(2))
      end
    end

    context "when two months have the same count" do
      before do
        create(:reading, user: user, read_at: Date.new(2023, 1, 5))
        create(:reading, user: user, read_at: Date.new(2023, 2, 10))
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

      it "returns zero streak days" do
        expect(context.longest_reading_streak_days).to(eq(0))
      end

      it "returns no streak start date" do
        expect(context.longest_reading_streak_start).to(be_nil)
      end

      it "returns no streak end date" do
        expect(context.longest_reading_streak_end).to(be_nil)
      end
    end
  end
end
