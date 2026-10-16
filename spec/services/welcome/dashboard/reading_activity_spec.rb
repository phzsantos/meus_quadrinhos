# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ReadingActivity) do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user) }

  subject(:context) { described_class.call(user: user) }

  around do |example|
    travel_to(Time.zone.local(2026, 10, 15, 12, 0, 0)) { example.run }
  end

  describe ".call" do
    it "builds a sunday-to-saturday grid ending today" do
      weeks = context.reading_activity_weeks

      expect(weeks.first.first[:date]).to(eq(Date.new(2025, 10, 12)))
      expect(weeks.first.first[:date].wday).to(eq(0))
      expect(weeks.last[4][:date]).to(eq(Date.new(2026, 10, 15)))
      expect(weeks.last[5]).to(be_nil)
      expect(weeks.last[6]).to(be_nil)
      expect(weeks).to(all(have_attributes(size: 7)))
    end

    it "labels months without crowding the first columns" do
      expect(context.reading_activity_months.size).to(eq(context.reading_activity_weeks.size))
      expect(context.reading_activity_months.first).to(eq(10))
      expect(context.reading_activity_months).to(include(1, 6, 10))
    end

    context "when the user has readings inside and outside the year" do
      before do
        create(:reading, user: user, read_at: Date.new(2026, 10, 15))
        create(:reading, user: user, read_at: Date.new(2026, 10, 15))
        create(:reading, user: user, read_at: Date.new(2026, 1, 1))
        create(:reading, user: user, read_at: Date.new(2024, 1, 1))
        create(:reading, read_at: Date.new(2026, 10, 15))
      end

      it "counts only this user's readings inside the visible year" do
        expect(context.reading_activity_total).to(eq(3))
      end

      it "counts a day as read from the first comic" do
        expect(day_on(Date.new(2026, 10, 15))[:count]).to(eq(2))
        expect(day_on(Date.new(2026, 1, 1))[:count]).to(eq(1))
        expect(day_on(Date.new(2026, 10, 14))[:count]).to(eq(0))
      end
    end

    context "when there are no readings" do
      it "returns an empty total and blank squares" do
        expect(context).to(be_success)
        expect(context.reading_activity_total).to(eq(0))
        expect(context.reading_activity_weeks.flatten.compact).to(all(include(count: 0)))
      end
    end
  end

  def day_on(date)
    context.reading_activity_weeks.flatten.compact.find { |day| day[:date] == date }
  end
end
