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

    context "quando não existem leituras" do
      it "retorna listas vazias" do
        expect(context.read_comics_months).to(eq([]))
        expect(context.read_comics_count_by_month).to(eq([]))
      end
    end
  end
end
