# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ReadingRecords) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are readings in different months" do
      before do
        create(:reading, read_at: Date.new(2023, 1, 5))
        create(:reading, read_at: Date.new(2023, 1, 20))
        create(:reading, read_at: Date.new(2023, 2, 10))
      end

      it "returns the month with the most comics read" do
        expect(context.best_month).to(eq(Date.new(2023, 1, 1)))
      end

      it "returns the count of comics read in the best month" do
        expect(context.best_month_comics_count).to(eq(2))
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

      it "returns the most recent month as the record" do
        expect(context.best_month).to(eq(Date.new(2023, 2, 1)))
      end
    end

    context "when there are no readings" do
      it "returns zero comics count" do
        expect(context.best_month_comics_count).to(eq(0))
      end

      it "returns no best month" do
        expect(context.best_month).to(be_nil)
      end
    end
  end
end
