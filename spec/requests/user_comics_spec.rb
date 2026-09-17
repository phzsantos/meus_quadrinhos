# frozen_string_literal: true

require "rails_helper"

RSpec.describe("UserComics", type: :request) do
  let(:user) { create(:user) }
  let(:comic) { create(:comic, title: "Owned Comic") }

  describe "POST /comics/:comic_id/user_comic" do
    before { sign_in user }

    it "creates ownership for the current user" do
      expect do
        post(comic_user_comic_path(comic))
      end.to(change { user.owned_comics.count }.by(1))

      expect(response).to(redirect_to(browse_comics_path))
    end
  end

  describe "DELETE /comics/:comic_id/user_comic" do
    before { sign_in user }

    it "removes ownership for the current user" do
      create(:user_comic, user: user, comic: comic)

      expect do
        delete(comic_user_comic_path(comic))
      end.to(change { user.owned_comics.count }.by(-1))

      expect(response).to(redirect_to(comic_path(comic)))
    end
  end
end
