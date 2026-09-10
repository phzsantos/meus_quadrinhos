# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::Organizer) do
  let(:user) { create(:user) }

  subject(:call_organizer) { described_class.call(user: user) }

  describe ".call" do
    it "runs the full dashboard flow without errors" do
      expect(call_organizer).to(be_success)
    end

    it "returns a shared context across all interactors" do
      expect(call_organizer).to(be_a(Interactor::Context))
    end
  end
end
