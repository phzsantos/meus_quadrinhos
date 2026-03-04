# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByMonth) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "quando existem leituras em diferentes meses" do
      before do
        create(:reading, read_at: Date.new(2023, 1, 5))
        create(:reading, read_at: Date.new(2023, 1, 20))
        create(:reading, read_at: Date.new(2023, 2, 10))
      end

      it "retorna os meses em que houve leitura, normalizados para o início do mês e em ordem cronológica" do
        expect(context.read_comics_months).to(eq(
          [
            Date.new(2023, 1, 1),
            Date.new(2023, 2, 1),
          ],
        ))
      end

      it "retorna a quantidade de leituras por mês respeitando a ordem dos meses" do
        expect(context.read_comics_count_by_month).to(eq([2, 1]))
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

      before do
        create(:reading, read_at: Date.new(2023, 1, 5))
        create(:reading, read_at: Date.new(2023, 2, 10))
      end

      it "não aplica filtro e retorna todos os meses" do
        expect(context.read_comics_months).to(eq(
          [
            Date.new(2023, 1, 1),
            Date.new(2023, 2, 1),
          ],
        ))
      end

      it "retorna todas as leituras" do
        expect(context.read_comics_count_by_month).to(eq([1, 1]))
      end
    end

    context "quando existe filtro por período" do
      subject(:context) do
        described_class.call(
          start_date: Date.new(2023, 2, 1),
          end_date: Date.new(2023, 2, 28),
        )
      end

      before do
        create(:reading, read_at: Date.new(2023, 1, 5))
        create(:reading, read_at: Date.new(2023, 2, 10))
        create(:reading, read_at: Date.new(2023, 2, 15))
      end

      it "retorna apenas os meses dentro do período informado" do
        expect(context.read_comics_months).to(eq(
          [Date.new(2023, 2, 1)],
        ))
      end

      it "retorna apenas as leituras dentro do período informado" do
        expect(context.read_comics_count_by_month).to(eq([2]))
      end
    end

    context "quando não existem leituras" do
      it "retorna listas vazias" do
        expect(context.read_comics_months).to(eq([]))
        expect(context.read_comics_count_by_month).to(eq([]))
      end
    end
  end
end
