# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Readings", type: :request) do
  let(:user) { create(:user) }
  let(:comic) { create(:comic, title: "Reading Comic") }

  describe "POST /comics/:comic_id/readings" do
    before { sign_in user }

    it "creates a reading for the current user" do
      expect do
        post(comic_readings_path(comic), params: { reading: { read_at: Date.new(2026, 1, 15) } })
      end.to(change { user.readings.count }.by(1))

      expect(response).to(redirect_to(comic_path(comic)))
      expect(user.readings.last).to(have_attributes(comic_id: comic.id, read_at: Date.new(2026, 1, 15)))
    end

    it "redirects to browse when requested" do
      post(
        comic_readings_path(comic),
        params: { return_to: "browse", reading: { read_at: Date.new(2026, 1, 15) } },
      )

      expect(response).to(redirect_to(browse_comics_path))
    end

    it "does not create a reading without a date" do
      expect do
        post(comic_readings_path(comic), params: { reading: { read_at: "" } })
      end.not_to(change(Reading, :count))

      expect(response).to(redirect_to(comic_path(comic)))
    end
  end
end
