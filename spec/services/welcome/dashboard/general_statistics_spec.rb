# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::GeneralStatistics) do
  include ActiveSupport::Testing::TimeHelpers

  subject(:context) { described_class.call }

  describe ".call" do
    around do |example|
      travel_to(Time.zone.local(2024, 3, 15, 12, 0, 0)) { example.run }
    end

    context "quando existem leituras em diferentes períodos" do
      let!(:comic_a) { create(:comic, page_count: 100, story_count: 2) }
      let!(:comic_b) { create(:comic, page_count: 200, story_count: 3) }

      before do
        # leitura no mês atual
        create(:reading, comic: comic_a, read_at: Time.current.beginning_of_month + 1.day)

        # leitura fora do mês atual
        create(:reading, comic: comic_b, read_at: 2.months.ago)
      end

      it "retorna o total de leituras realizadas" do
        expect(context.total_comics_read).to(eq(2))
      end

      it "retorna o total de histórias lidas" do
        expect(context.total_story_count).to(eq(5))
      end

      it "retorna o total de páginas lidas" do
        expect(context.total_pages_read).to(eq(300))
      end

      it "retorna a quantidade de leituras realizadas no mês atual" do
        expect(context.comics_read_this_month).to(eq(1))
      end

      it "executa o fluxo com sucesso" do
        expect(context).to(be_success)
      end
    end

    context "quando não existem leituras" do
      it "retorna todos os contadores como zero" do
        expect(context.total_comics_read).to(eq(0))
        expect(context.total_story_count).to(eq(0))
        expect(context.total_pages_read).to(eq(0))
        expect(context.comics_read_this_month).to(eq(0))
      end
    end
  end
end
