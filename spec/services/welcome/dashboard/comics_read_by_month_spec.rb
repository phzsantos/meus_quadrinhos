# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByMonth) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are readings in different months" do
      before do
        create(:reading, read_at: Date.new(2023, 1, 5))
        create(:reading, read_at: Date.new(2023, 1, 20))
        create(:reading, read_at: Date.new(2023, 2, 10))
      end

      it "returns months with readings, normalized to the start of the month and in chronological order" do
        expect(context.read_comics_months).to(eq(
          [
            Date.new(2023, 1, 1),
            Date.new(2023, 2, 1),
          ],
        ))
      end

      it "returns reading counts per month respecting month order" do
        expect(context.read_comics_count_by_month).to(eq([2, 1]))
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

      before do
        create(:reading, read_at: Date.new(2023, 1, 5))
        create(:reading, read_at: Date.new(2023, 2, 10))
      end

      it "does not apply filter and returns all months" do
        expect(context.read_comics_months).to(eq(
          [
            Date.new(2023, 1, 1),
            Date.new(2023, 2, 1),
          ],
        ))
      end

      it "returns all readings" do
        expect(context.read_comics_count_by_month).to(eq([1, 1]))
      end
    end

    context "when there is a date range filter" do
      subject(:context) do
        described_class.call(
          start_date: Date.new(2023, 2, 1),
          end_date: Date.new(2023, 2, 28),
        )
      end

      before do
        create(:reading, read_at: Date.new(2023, 1, 5))
        create(:reading, read_at: Date.new(2023, 2, 10))
        create(:reading, read_at: Date.new(2023, 2, 15))
      end

      it "returns only months within the given period" do
        expect(context.read_comics_months).to(eq(
          [Date.new(2023, 2, 1)],
        ))
      end

      it "returns only readings within the given period" do
        expect(context.read_comics_count_by_month).to(eq([2]))
      end
    end

    context "when there are no readings" do
      it "returns an empty list of months with readings" do
        expect(context.read_comics_months).to(eq([]))
      end

      it "returns an empty list of reading counts per month" do
        expect(context.read_comics_count_by_month).to(eq([]))
      end
    end
  end
end
