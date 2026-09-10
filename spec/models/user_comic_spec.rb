# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UserComic, type: :model) do
  subject(:user_comic) { build(:user_comic) }

  describe "associations" do
    it { is_expected.to(belong_to(:user)) }
    it { is_expected.to(belong_to(:comic)) }
  end

  describe "validations" do
    it "does not allow the same comic twice for the same user" do
      existing = create(:user_comic)
      duplicate = build(:user_comic, user: existing.user, comic: existing.comic)

      expect(duplicate).not_to(be_valid)
      expect(duplicate.errors[:comic_id]).to(be_present)
    end

    it "allows the same comic for different users" do
      existing = create(:user_comic)
      other = build(:user_comic, user: create(:user), comic: existing.comic)

      expect(other).to(be_valid)
    end
  end
end
