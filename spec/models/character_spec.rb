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
