# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Collection, type: :model) do
  subject(:collection) { build(:collection) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
    it { is_expected.to(validate_uniqueness_of(:name).case_insensitive) }
  end

  describe "associations" do
    it { is_expected.to(have_many(:comics).dependent(:nullify)) }
  end

  describe ".with_comics_visible_to" do
    let(:user) { create(:user) }

    it "returns only collections with comics owned or read by the user" do
      visible_collection = create(:collection, name: "Visible")
      hidden_collection = create(:collection, name: "Hidden")
      visible_comic = create(:comic, collection: visible_collection)
      create(:comic, collection: hidden_collection)
      create(:user_comic, user: user, comic: visible_comic)

      expect(described_class.with_comics_visible_to(user)).to(contain_exactly(visible_collection))
    end

    it "returns every collection when the user is an admin" do
      admin = create(:user, :admin)
      owned_collection = create(:collection, name: "Owned")
      other_collection = create(:collection, name: "Other")
      empty_collection = create(:collection, name: "Empty")
      owned_comic = create(:comic, collection: owned_collection)
      create(:comic, collection: other_collection)
      create(:user_comic, user: admin, comic: owned_comic)

      expect(described_class.with_comics_visible_to(admin)).to(contain_exactly(
        owned_collection,
        other_collection,
        empty_collection,
      ))
    end
  end

  describe "friendly_id" do
    it "generates slug from name" do
      collection = create(:collection, name: "Justiceiro: Deluxe")

      expect(collection.slug).to(eq("justiceiro-deluxe"))
    end

    it "updates slug when name changes" do
      collection = create(:collection, name: "Justiceiro: Deluxe")

      collection.update!(name: "Justiceiro: Omnibus")

      expect(collection.slug).to(eq("justiceiro-omnibus"))
    end
  end
end
