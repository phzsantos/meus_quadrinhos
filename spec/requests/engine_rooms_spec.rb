# frozen_string_literal: true

require "rails_helper"

RSpec.describe("EngineRooms", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /engine-room" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get engine_room_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get engine_room_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end
end
