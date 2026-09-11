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
