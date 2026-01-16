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
    it "gera slug a partir do nome" do
      publisher = create(:publisher, name: "Panini")

      expect(publisher.slug).to(eq("panini"))
    end

    it "atualiza o slug quando o nome muda" do
      publisher = create(:publisher, name: "Panini")

      publisher.update!(name: "Mythos")

      expect(publisher.slug).to(eq("mythos"))
    end
  end
end
