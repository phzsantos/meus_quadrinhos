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

  describe "friendly_id" do
    it "gera slug a partir do nome" do
      paper_type = create(:paper_type, name: "Couchê")

      expect(paper_type.slug).to(eq("couche"))
    end

    it "atualiza o slug quando o nome muda" do
      paper_type = create(:paper_type, name: "Offset")

      paper_type.update!(name: "Pólen")

      expect(paper_type.slug).to(eq("polen"))
    end
  end
end
