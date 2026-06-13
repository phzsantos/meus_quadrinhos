# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::LatestReadings) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are more than six readings" do
      before do
        # older readings
        3.times do |i|
          create(
            :reading,
            read_at: Date.new(2023, 1, i + 1),
            created_at: Time.zone.parse("2023-01-01 10:00:00"),
          )
        end

        # most recent readings
        4.times do |i|
          create(
            :reading,
            read_at: Date.new(2023, 2, i + 1),
            created_at: Time.zone.parse("2023-02-01 #{10 + i}:00:00"),
          )
        end
      end

      it "returns only the six most recent readings" do
        expect(context.latest_readings.size).to(eq(6))
      end

      it "returns readings ordered from most recent to oldest" do
        dates = context.latest_readings.map(&:read_at)

        expect(dates).to(eq(dates.sort.reverse))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are fewer than six readings" do
      before do
        create(:reading, read_at: Date.new(2023, 3, 10))
        create(:reading, read_at: Date.new(2023, 3, 5))
      end

      it "returns all existing readings" do
        expect(context.latest_readings.size).to(eq(2))
      end
    end

    context "when there are no readings" do
      it "returns an empty collection" do
        expect(context.latest_readings).to(be_empty)
      end
    end
  end
end
