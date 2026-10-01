# frozen_string_literal: true

require "rails_helper"

RSpec.describe(BookBinding, type: :model) do
  subject(:book_binding) { build(:book_binding) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
  end

  describe "associations" do
    it { is_expected.to(have_many(:comics).dependent(:restrict_with_error)) }
  end

  describe ".with_comics_visible_to" do
    let(:user) { create(:user) }

    it "returns only book bindings with comics owned or read by the user" do
      visible_binding = create(:book_binding, name: "Visible")
      hidden_binding = create(:book_binding, name: "Hidden")
      visible_comic = create(:comic, book_binding: visible_binding)
      create(:comic, book_binding: hidden_binding)
      create(:user_comic, user: user, comic: visible_comic)

      expect(described_class.with_comics_visible_to(user)).to(contain_exactly(visible_binding))
    end

    it "returns every book binding when the user is an admin" do
      admin = create(:user, :admin)
      owned_binding = create(:book_binding, name: "Owned")
      other_binding = create(:book_binding, name: "Other")
      empty_binding = create(:book_binding, name: "Empty")
      owned_comic = create(:comic, book_binding: owned_binding)
      create(:comic, book_binding: other_binding)
      create(:user_comic, user: admin, comic: owned_comic)

      expect(described_class.with_comics_visible_to(admin)).to(contain_exactly(
        owned_binding,
        other_binding,
        empty_binding,
      ))
    end
  end

  describe "friendly_id" do
    it "generates slug from name" do
      book_binding = create(:book_binding, name: "Capa cartão")

      expect(book_binding.slug).to(eq("capa-cartao"))
    end

    it "updates slug when name changes" do
      book_binding = create(:book_binding, name: "Capa cartão")

      book_binding.update!(name: "Capa dura")

      expect(book_binding.slug).to(eq("capa-dura"))
    end
  end
end
