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
