# frozen_string_literal: true

require "rails_helper"

RSpec.describe("ComicMemberships", type: :request) do
  let(:user) { create(:user) }
  let(:comic) { create(:comic, title: "Membership Comic") }

  describe "GET /comics/:comic_id/membership/edit" do
    before { sign_in user }

    it "shows the membership form" do
      get edit_comic_membership_path(comic)

      expect(response).to(have_http_status(:ok))
      expect(response.body).to(include("Editar na sua coleção"))
      expect(response.body).to(include("Tenho"))
      expect(response.body).to(include("Leituras"))
      expect(response.body).not_to(include("name=\"comic[title]\""))
    end
  end

  describe "PATCH /comics/:comic_id/membership" do
    before { sign_in user }

    it "does not update comic catalog attributes" do
      patch comic_membership_path(comic), params: {
        membership: { owned: "1" },
        comic: { title: "New Title", readings_attributes: { "0" => { read_at: "2026-03-01" } } },
      }

      expect(response).to(redirect_to(comic_path(comic)))
      expect(comic.reload.title).not_to(eq("New Title"))
    end

    it "adds ownership and a reading" do
      expect do
        patch(comic_membership_path(comic), params: {
          membership: { owned: "1" },
          comic: { readings_attributes: { "0" => { read_at: "2026-03-01" } } },
        })
      end.to(change { user.owned_comics.count }.by(1)
        .and(change { user.readings.count }.by(1)))

      expect(response).to(redirect_to(comic_path(comic)))
      expect(user.readings.last).to(have_attributes(comic_id: comic.id, read_at: Date.new(2026, 3, 1)))
    end

    it "removes ownership when unchecked" do
      create(:user_comic, user: user, comic: comic)

      expect do
        patch(comic_membership_path(comic), params: {
          membership: { owned: "0" },
          comic: { readings_attributes: {} },
        })
      end.to(change { user.owned_comics.count }.by(-1))

      expect(response).to(redirect_to(comic_path(comic)))
    end
  end
end
