# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByBookBinding) do
  subject(:context) { described_class.call }

  describe ".call" do
    context "when there are readings" do
      let!(:capa_dura) { create(:book_binding, name: "Capa dura") }
      let!(:capa_cartao) { create(:book_binding, name: "Capa cartão") }
      let!(:comic_capa_dura_a) { create(:comic, book_binding: capa_dura) }
      let!(:comic_capa_dura_b) { create(:comic, book_binding: capa_dura) }
      let!(:comic_capa_cartao) { create(:comic, book_binding: capa_cartao) }

      before do
        create(:reading, comic: comic_capa_dura_a, read_at: Date.new(2022, 5, 10))
        create(:reading, comic: comic_capa_dura_b, read_at: Date.new(2023, 8, 3))
        create(:reading, comic: comic_capa_cartao, read_at: Date.new(2023, 1, 20))
      end

      it "returns book bindings with readings ordered by count descending" do
        expect(context.read_comics_book_bindings).to(eq(["Capa dura", "Capa cartão"]))
      end

      it "returns reading counts per book binding respecting book binding order" do
        expect(context.read_comics_count_by_book_binding).to(eq([2, 1]))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are no readings" do
      it "returns an empty list of book bindings with readings" do
        expect(context.read_comics_book_bindings).to(eq([]))
      end

      it "returns an empty list of reading counts per book binding" do
        expect(context.read_comics_count_by_book_binding).to(eq([]))
      end
    end
  end
end
