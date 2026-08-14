# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Welcome", type: :request) do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /" do
    let(:context_double) do
      instance_double(
        "Welcome::Dashboard::Context",
        read_comics_years: [2023, 2024],
        read_comics_count_by_year: [10, 20],

        pages_read_years: [2023, 2024],
        pages_read_count_by_year: [300, 600],

        read_comics_publishers: ["Abril", "Panini"],
        read_comics_count_by_publisher: [5, 15],

        read_comics_months: [
          Date.new(2024, 1, 1),
          Date.new(2024, 2, 1),
        ],
        read_comics_count_by_month: [2, 3],

        pages_read_months: [
          Date.new(2024, 1, 1),
          Date.new(2024, 2, 1),
        ],
        pages_read_count_by_month: [50, 80],

        read_stories_months: [
          Date.new(2024, 1, 1),
          Date.new(2024, 2, 1),
        ],
        read_stories_count_by_month: [10, 20],

        read_comics_comparison_days: (1..31).to_a,
        read_comics_count_by_day_current: (1..31).to_a,
        read_comics_count_by_day_previous: (1..31).to_a,
        read_comics_comparison_current_label: "02/2023",
        read_comics_comparison_previous_label: "01/2023",

        latest_readings: [],
        total_comics_read: 30,
        total_story_count: 120,
        total_pages_read: 900,
        comics_read_this_month: 3,
      )
    end

    before do
      allow(Welcome::Dashboard::Organizer)
        .to(receive(:call)
        .and_return(context_double))
    end

    it "returns success" do
      get root_path
      expect(response).to(have_http_status(:ok))
    end

    it "calls the dashboard organizer" do
      get root_path
      expect(Welcome::Dashboard::Organizer).to(have_received(:call))
    end
  end
end
