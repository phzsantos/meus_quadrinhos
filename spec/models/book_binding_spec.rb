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
