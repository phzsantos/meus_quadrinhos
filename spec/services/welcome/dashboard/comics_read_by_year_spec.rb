# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByYear) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "quando existem leituras" do
      before do
        create(:reading, read_at: Date.new(2022, 5, 10))
        create(:reading, read_at: Date.new(2022, 8, 3))
        create(:reading, read_at: Date.new(2023, 1, 20))
      end

      it "retorna os anos em que houve leitura, em ordem crescente" do
        expect(context.read_comics_years).to(eq([2022, 2023]))
      end

      it "retorna a quantidade de leituras por ano respeitando a ordem dos anos" do
        expect(context.read_comics_count_by_year).to(eq([2, 1]))
      end

      it "executa o fluxo com sucesso" do
        expect(context).to(be_success)
      end
    end

    context "quando não existem leituras" do
      it "retorna listas vazias" do
        expect(context.read_comics_years).to(eq([]))
        expect(context.read_comics_count_by_year).to(eq([]))
      end
    end
  end
end
