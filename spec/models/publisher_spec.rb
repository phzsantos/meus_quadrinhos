# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Publisher, type: :model) do
  subject(:publisher) { build(:publisher) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
    it { is_expected.to(validate_uniqueness_of(:name).case_insensitive) }
  end

  describe "associations" do
    it { is_expected.to(have_many(:comics).dependent(:restrict_with_error)) }
  end

  describe ".with_comics_visible_to" do
    let(:user) { create(:user) }

    it "returns only publishers with comics owned or read by the user" do
      visible_publisher = create(:publisher, name: "Visible")
      hidden_publisher = create(:publisher, name: "Hidden")
      visible_comic = create(:comic, publisher: visible_publisher)
      create(:comic, publisher: hidden_publisher)
      create(:user_comic, user: user, comic: visible_comic)

      expect(described_class.with_comics_visible_to(user)).to(contain_exactly(visible_publisher))
    end

    it "returns every publisher when the user is an admin" do
      admin = create(:user, :admin)
      owned_publisher = create(:publisher, name: "Owned")
      other_publisher = create(:publisher, name: "Other")
      empty_publisher = create(:publisher, name: "Empty")
      owned_comic = create(:comic, publisher: owned_publisher)
      create(:comic, publisher: other_publisher)
      create(:user_comic, user: admin, comic: owned_comic)

      expect(described_class.with_comics_visible_to(admin)).to(contain_exactly(
        owned_publisher,
        other_publisher,
        empty_publisher,
      ))
    end
  end

  describe ".with_visible_comics_count" do
    let(:user) { create(:user) }

    it "annotates each publisher with the count of comics visible to the user" do
      publisher = create(:publisher)
      visible_comic = create(:comic, publisher: publisher)
      create(:comic, publisher: publisher)
      create(:user_comic, user: user, comic: visible_comic)

      counted = described_class.with_visible_comics_count(user).find(publisher.id)

      expect(counted[:visible_comics_count].to_i).to(eq(1))
    end
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
