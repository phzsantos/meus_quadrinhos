# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByYear) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are readings" do
      before do
        create(:reading, read_at: Date.new(2022, 5, 10))
        create(:reading, read_at: Date.new(2022, 8, 3))
        create(:reading, read_at: Date.new(2023, 1, 20))
      end

      it "returns years with readings in ascending order" do
        expect(context.read_comics_years).to(eq([2022, 2023]))
      end

      it "returns reading counts per year respecting year order" do
        expect(context.read_comics_count_by_year).to(eq([2, 1]))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are no readings" do
      it "returns an empty list of years with readings" do
        expect(context.read_comics_years).to(eq([]))
      end

      it "returns an empty list of reading counts per year" do
        expect(context.read_comics_count_by_year).to(eq([]))
      end
    end
  end
end
