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
