# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByDayComparison) do
  subject(:context) { described_class.call(reference_date: Date.new(2023, 2, 15)) }

  describe ".call" do
    context "when there are readings in the current and previous months" do
      before do
        create(:reading, read_at: Date.new(2023, 2, 5))
        create(:reading, read_at: Date.new(2023, 2, 5))
        create(:reading, read_at: Date.new(2023, 2, 10))
        create(:reading, read_at: Date.new(2023, 1, 5))
        create(:reading, read_at: Date.new(2023, 1, 20))
        create(:reading, read_at: Date.new(2022, 12, 15))
      end

      it "returns days covering the longer of the two months" do
        expect(context.read_comics_comparison_days).to(eq((1..31).to_a))
      end

      it "returns current month daily counts" do
        counts = context.read_comics_count_by_day_current

        expect(counts[4]).to(eq(2))
        expect(counts[9]).to(eq(1))
        expect(counts.sum).to(eq(3))
      end

      it "returns previous month daily counts" do
        counts = context.read_comics_count_by_day_previous

        expect(counts[4]).to(eq(1))
        expect(counts[19]).to(eq(1))
        expect(counts.sum).to(eq(2))
      end

      it "returns month labels" do
        expect(context.read_comics_comparison_current_label).to(eq("02/2023"))
        expect(context.read_comics_comparison_previous_label).to(eq("01/2023"))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when comparing months with different lengths" do
      subject(:context) { described_class.call(reference_date: Date.new(2023, 3, 10)) }

      before do
        create(:reading, read_at: Date.new(2023, 2, 28))
        create(:reading, read_at: Date.new(2023, 3, 31))
      end

      it "zero-fills days that do not exist in February" do
        expect(context.read_comics_count_by_day_previous[27]).to(eq(1))
        expect(context.read_comics_count_by_day_previous[28]).to(eq(0))
        expect(context.read_comics_count_by_day_previous[29]).to(eq(0))
        expect(context.read_comics_count_by_day_previous[30]).to(eq(0))
      end

      it "keeps March day 31" do
        expect(context.read_comics_count_by_day_current[30]).to(eq(1))
      end
    end

    context "when there are no readings" do
      it "returns zeros for both series" do
        expect(context.read_comics_count_by_day_current).to(eq(Array.new(31, 0)))
        expect(context.read_comics_count_by_day_previous).to(eq(Array.new(31, 0)))
      end
    end

    context "when reference_date is not provided" do
      subject(:context) { described_class.call }

      let(:reference_date) { Time.current.to_date }
      let(:previous_month_start) { (reference_date - 1.month).beginning_of_month }

      before do
        create(:reading, read_at: reference_date.beginning_of_month + 2.days)
        create(:reading, read_at: previous_month_start + 4.days)
      end

      it "uses the current and previous calendar months" do
        max_day = [reference_date.end_of_month.day, previous_month_start.end_of_month.day].max

        expect(context.read_comics_comparison_current_label).to(eq(reference_date.beginning_of_month.strftime("%m/%Y")))
        expect(context.read_comics_comparison_previous_label).to(eq(previous_month_start.strftime("%m/%Y")))
        expect(context.read_comics_comparison_days).to(eq((1..max_day).to_a))
        expect(context.read_comics_count_by_day_current[2]).to(eq(1))
        expect(context.read_comics_count_by_day_previous[4]).to(eq(1))
      end
    end
  end
end
