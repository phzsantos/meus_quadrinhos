# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Publisher, type: :model) do
  subject(:publisher) { build(:publisher) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
  end

  describe "associations" do
    it { is_expected.to(have_many(:comics).dependent(:restrict_with_error)) }
  end

  describe "friendly_id" do
    it "generates slug from name" do
      publisher = create(:publisher, name: "Panini")

      expect(publisher.slug).to(eq("panini"))
    end

    it "updates slug when name changes" do
      publisher = create(:publisher, name: "Panini")

      publisher.update!(name: "Mythos")

      expect(publisher.slug).to(eq("mythos"))
    end
  end
end
