# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Character, type: :model) do
  subject(:character) { build(:character) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
    it { is_expected.to(validate_uniqueness_of(:name).case_insensitive) }
  end

  describe "associations" do
    it { is_expected.to(have_many(:comic_characters).dependent(:restrict_with_error)) }
    it { is_expected.to(have_many(:comics).through(:comic_characters)) }
  end

  describe ".with_comics_visible_to" do
    let(:user) { create(:user) }

    it "returns only characters with comics owned or read by the user" do
      visible_character = create(:character, name: "Visible")
      hidden_character = create(:character, name: "Hidden")
      visible_comic = create(:comic, characters: [visible_character])
      create(:comic, characters: [hidden_character])
      create(:user_comic, user: user, comic: visible_comic)

      expect(described_class.with_comics_visible_to(user)).to(contain_exactly(visible_character))
    end

    it "returns every character when the user is an admin" do
      admin = create(:user, :admin)
      owned_character = create(:character, name: "Owned")
      other_character = create(:character, name: "Other")
      empty_character = create(:character, name: "Empty")
      owned_comic = create(:comic, characters: [owned_character])
      create(:comic, characters: [other_character])
      create(:user_comic, user: admin, comic: owned_comic)

      expect(described_class.with_comics_visible_to(admin)).to(contain_exactly(
        owned_character,
        other_character,
        empty_character,
      ))
    end
  end

  describe "friendly_id" do
    it "generates slug from name" do
      character = create(:character, name: "Bruce Wayne")

      expect(character.slug).to(eq("bruce-wayne"))
    end

    it "updates slug when name changes" do
      character = create(:character, name: "Bruce Wayne")

      character.update!(name: "Batman")

      expect(character.slug).to(eq("batman"))
    end
  end
end
