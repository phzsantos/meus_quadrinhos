# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::PagesReadByYear) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "quando existem leituras em diferentes anos" do
      let!(:comic_2022_a) { create(:comic, page_count: 100) }
      let!(:comic_2022_b) { create(:comic, page_count: 150) }
      let!(:comic_2023)   { create(:comic, page_count: 200) }

      before do
        create(:reading, comic: comic_2022_a, read_at: Date.new(2022, 3, 10))
        create(:reading, comic: comic_2022_b, read_at: Date.new(2022, 7, 5))
        create(:reading, comic: comic_2023,   read_at: Date.new(2023, 1, 20))
      end

      it "retorna os anos em que houve leitura, em ordem crescente" do
        expect(context.pages_read_years).to(eq([2022, 2023]))
      end

      it "retorna o total de páginas lidas por ano respeitando a ordem dos anos" do
        expect(context.pages_read_count_by_year).to(eq([250, 200]))
      end

      it "executa o fluxo com sucesso" do
        expect(context).to(be_success)
      end
    end

    context "quando não existem leituras" do
      it "retorna listas vazias" do
        expect(context.pages_read_years).to(eq([]))
        expect(context.pages_read_count_by_year).to(eq([]))
      end
    end
  end
end
