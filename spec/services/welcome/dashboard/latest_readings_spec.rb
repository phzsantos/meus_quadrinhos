# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::LatestReadings) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "quando existem mais de seis leituras" do
      before do
        # leituras mais antigas
        3.times do |i|
          create(
            :reading,
            read_at: Date.new(2023, 1, i + 1),
            created_at: Time.zone.parse("2023-01-01 10:00:00"),
          )
        end

        # leituras mais recentes
        4.times do |i|
          create(
            :reading,
            read_at: Date.new(2023, 2, i + 1),
            created_at: Time.zone.parse("2023-02-01 #{10 + i}:00:00"),
          )
        end
      end

      it "retorna apenas as seis leituras mais recentes" do
        expect(context.latest_readings.size).to(eq(6))
      end

      it "retorna as leituras ordenadas da mais recente para a mais antiga" do
        dates = context.latest_readings.map(&:read_at)

        expect(dates).to(eq(dates.sort.reverse))
      end

      it "executa o fluxo com sucesso" do
        expect(context).to(be_success)
      end
    end

    context "quando existem menos de seis leituras" do
      before do
        create(:reading, read_at: Date.new(2023, 3, 10))
        create(:reading, read_at: Date.new(2023, 3, 5))
      end

      it "retorna todas as leituras existentes" do
        expect(context.latest_readings.size).to(eq(2))
      end
    end

    context "quando não existem leituras" do
      it "retorna uma coleção vazia" do
        expect(context.latest_readings).to(be_empty)
      end
    end
  end
end
