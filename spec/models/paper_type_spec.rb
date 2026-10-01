# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PaperType, type: :model) do
  subject(:paper_type) { build(:paper_type) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
  end

  describe "associations" do
    it { is_expected.to(have_many(:comics).dependent(:restrict_with_error)) }
  end

  describe ".with_comics_visible_to" do
    let(:user) { create(:user) }

    it "returns only paper types with comics owned or read by the user" do
      visible_paper = create(:paper_type, name: "Visible")
      hidden_paper = create(:paper_type, name: "Hidden")
      visible_comic = create(:comic, paper_type: visible_paper)
      create(:comic, paper_type: hidden_paper)
      create(:user_comic, user: user, comic: visible_comic)

      expect(described_class.with_comics_visible_to(user)).to(contain_exactly(visible_paper))
    end

    it "returns every paper type when the user is an admin" do
      admin = create(:user, :admin)
      owned_paper = create(:paper_type, name: "Owned")
      other_paper = create(:paper_type, name: "Other")
      empty_paper = create(:paper_type, name: "Empty")
      owned_comic = create(:comic, paper_type: owned_paper)
      create(:comic, paper_type: other_paper)
      create(:user_comic, user: admin, comic: owned_comic)

      expect(described_class.with_comics_visible_to(admin)).to(contain_exactly(
        owned_paper,
        other_paper,
        empty_paper,
      ))
    end
  end

  describe "friendly_id" do
    it "generates slug from name" do
      paper_type = create(:paper_type, name: "Couchê")

      expect(paper_type.slug).to(eq("couche"))
    end

    it "updates slug when name changes" do
      paper_type = create(:paper_type, name: "Offset")

      paper_type.update!(name: "Pólen")

      expect(paper_type.slug).to(eq("polen"))
    end
  end
end
