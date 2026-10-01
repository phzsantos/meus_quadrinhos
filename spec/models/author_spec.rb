# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Author, type: :model) do
  subject(:author) { build(:author) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
    it { is_expected.to(validate_uniqueness_of(:name).case_insensitive) }
  end

  describe "associations" do
    it { is_expected.to(have_many(:comic_authors).dependent(:restrict_with_error)) }
    it { is_expected.to(have_many(:comics).through(:comic_authors)) }
  end

  describe ".with_comics_visible_to" do
    let(:user) { create(:user) }

    it "returns only authors with comics owned or read by the user" do
      visible_author = create(:author, name: "Visible")
      hidden_author = create(:author, name: "Hidden")
      visible_comic = create(:comic, authors: [visible_author])
      create(:comic, authors: [hidden_author])
      create(:user_comic, user: user, comic: visible_comic)

      expect(described_class.with_comics_visible_to(user)).to(contain_exactly(visible_author))
    end

    it "returns every author when the user is an admin" do
      admin = create(:user, :admin)
      owned_author = create(:author, name: "Owned")
      other_author = create(:author, name: "Other")
      empty_author = create(:author, name: "Empty")
      owned_comic = create(:comic, authors: [owned_author])
      create(:comic, authors: [other_author])
      create(:user_comic, user: admin, comic: owned_comic)

      expect(described_class.with_comics_visible_to(admin)).to(contain_exactly(
        owned_author,
        other_author,
        empty_author,
      ))
    end
  end

  describe "friendly_id" do
    it "generates slug from name" do
      author = create(:author, name: "Alan Moore")

      expect(author.slug).to(eq("alan-moore"))
    end

    it "generates new slug when name changes" do
      author = create(:author, name: "Alan Moore")

      author.update!(name: "Grant Morrison")

      expect(author.slug).to(eq("grant-morrison"))
    end
  end
end
