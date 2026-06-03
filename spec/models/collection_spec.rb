# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Collection, type: :model) do
  subject(:collection) { build(:collection) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
    it { is_expected.to(validate_uniqueness_of(:name).case_insensitive) }
  end

  describe "associations" do
    it { is_expected.to(have_many(:comics).dependent(:nullify)) }
  end

  describe "friendly_id" do
    it "gera slug a partir do nome" do
      collection = create(:collection, name: "Justiceiro: Deluxe")

      expect(collection.slug).to(eq("justiceiro-deluxe"))
    end

    it "atualiza o slug quando o nome muda" do
      collection = create(:collection, name: "Justiceiro: Deluxe")

      collection.update!(name: "Justiceiro: Omnibus")

      expect(collection.slug).to(eq("justiceiro-omnibus"))
    end
  end
end
