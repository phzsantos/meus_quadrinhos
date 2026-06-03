# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::PagesReadByMonth) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "quando existem leituras em diferentes meses" do
      let!(:comic_jan) { create(:comic, page_count: 120) }
      let!(:comic_jan_2) { create(:comic, page_count: 80) }
      let!(:comic_feb) { create(:comic, page_count: 200) }

      before do
        create(:reading, comic: comic_jan,   read_at: Date.new(2023, 1, 5))
        create(:reading, comic: comic_jan_2, read_at: Date.new(2023, 1, 25))
        create(:reading, comic: comic_feb,   read_at: Date.new(2023, 2, 10))
      end

      it "retorna os meses em que houve leitura, normalizados para o início do mês e em ordem cronológica" do
        expect(context.pages_read_months).to(eq(
          [
            Date.new(2023, 1, 1),
            Date.new(2023, 2, 1),
          ],
        ))
      end

      it "retorna o total de páginas lidas por mês respeitando a ordem dos meses" do
        expect(context.pages_read_count_by_month).to(eq([200, 200]))
      end

      it "executa o fluxo com sucesso" do
        expect(context).to(be_success)
      end
    end

    context "quando start_date é nil" do
      subject(:context) do
        described_class.call(
          start_date: nil,
          end_date: nil,
        )
      end

      let!(:comic_jan) { create(:comic, page_count: 120) }
      let!(:comic_feb) { create(:comic, page_count: 200) }

      before do
        create(:reading, comic: comic_jan, read_at: Date.new(2023, 1, 10))
        create(:reading, comic: comic_feb, read_at: Date.new(2023, 2, 10))
      end

      it "não aplica filtro e retorna todos os meses" do
        expect(context.pages_read_months).to(eq(
          [
            Date.new(2023, 1, 1),
            Date.new(2023, 2, 1),
          ],
        ))
      end
    end

    context "quando existe filtro por período" do
      subject(:context) do
        described_class.call(
          start_date: Date.new(2023, 2, 1),
          end_date: Date.new(2023, 2, 28),
        )
      end

      let!(:comic_jan) { create(:comic, page_count: 120) }
      let!(:comic_feb) { create(:comic, page_count: 200) }

      before do
        create(:reading, comic: comic_jan, read_at: Date.new(2023, 1, 10))
        create(:reading, comic: comic_feb, read_at: Date.new(2023, 2, 10))
      end

      it "retorna apenas os meses dentro do período informado" do
        expect(context.pages_read_months).to(eq(
          [Date.new(2023, 2, 1)],
        ))
      end

      it "retorna apenas as páginas dentro do período informado" do
        expect(context.pages_read_count_by_month).to(eq([200]))
      end
    end

    context "quando não existem leituras" do
      it "retorna lista de meses em que houve leitura vazia" do
        expect(context.pages_read_months).to(eq([]))
      end

      it "retorna lista de páginas lidas por mês vazia" do
        expect(context.pages_read_count_by_month).to(eq([]))
      end
    end
  end
end
