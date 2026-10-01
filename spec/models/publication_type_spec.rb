# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PublicationType, type: :model) do
  subject(:publication_type) { build(:publication_type) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
  end

  describe "associations" do
    it { is_expected.to(have_many(:comics).dependent(:restrict_with_error)) }
  end

  describe ".with_comics_visible_to" do
    let(:user) { create(:user) }

    it "returns only publication types with comics owned or read by the user" do
      visible_type = create(:publication_type, name: "Visible")
      hidden_type = create(:publication_type, name: "Hidden")
      visible_comic = create(:comic, publication_type: visible_type)
      create(:comic, publication_type: hidden_type)
      create(:user_comic, user: user, comic: visible_comic)

      expect(described_class.with_comics_visible_to(user)).to(contain_exactly(visible_type))
    end

    it "returns every publication type when the user is an admin" do
      admin = create(:user, :admin)
      owned_type = create(:publication_type, name: "Owned")
      other_type = create(:publication_type, name: "Other")
      empty_type = create(:publication_type, name: "Empty")
      owned_comic = create(:comic, publication_type: owned_type)
      create(:comic, publication_type: other_type)
      create(:user_comic, user: admin, comic: owned_comic)

      expect(described_class.with_comics_visible_to(admin)).to(contain_exactly(
        owned_type,
        other_type,
        empty_type,
      ))
    end
  end

  describe "friendly_id" do
    it "generates slug from name" do
      publication_type = create(:publication_type, name: "HQ")

      expect(publication_type.slug).to(eq("hq"))
    end

    it "updates slug when name changes" do
      publication_type = create(:publication_type, name: "HQ")

      publication_type.update!(name: "Mangá")

      expect(publication_type.slug).to(eq("manga"))
    end
  end
end
