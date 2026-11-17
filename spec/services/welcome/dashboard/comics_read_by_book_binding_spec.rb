# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::ComicsReadByBookBinding) do
  let(:user) { create(:user) }

  subject(:context) { described_class.call(user: user) }

  describe ".call" do
    context "when there are readings" do
      let!(:capa_dura) { create(:book_binding, name: "Capa dura") }
      let!(:capa_cartao) { create(:book_binding, name: "Capa cartão") }
      let!(:comic_capa_dura_a) { create(:comic, book_binding: capa_dura) }
      let!(:comic_capa_dura_b) { create(:comic, book_binding: capa_dura) }
      let!(:comic_capa_cartao) { create(:comic, book_binding: capa_cartao) }

      before do
        create(:reading, user: user, comic: comic_capa_dura_a, read_at: Date.new(2022, 5, 10))
        create(:reading, user: user, comic: comic_capa_dura_b, read_at: Date.new(2023, 8, 3))
        create(:reading, user: user, comic: comic_capa_cartao, read_at: Date.new(2023, 1, 20))
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

    context "when there are more than seven book bindings with readings" do
      before do
        8.times do |index|
          book_binding = create(:book_binding, name: "Binding #{index}")
          comic = create(:comic, book_binding: book_binding)

          (8 - index).times do
            create(:reading, user: user, comic: comic, read_at: Date.new(2023, 1, index + 1))
          end
        end
      end

      it "returns only the top seven book bindings" do
        expect(context.read_comics_book_bindings.size).to(eq(7))
      end

      it "returns the seven most read book bindings in descending order" do
        expect(context.read_comics_book_bindings).to(eq(
          [
            "Binding 0",
            "Binding 1",
            "Binding 2",
            "Binding 3",
            "Binding 4",
            "Binding 5",
            "Binding 6",
          ],
        ))
      end

      it "returns reading counts for the top seven book bindings" do
        expect(context.read_comics_count_by_book_binding).to(eq([8, 7, 6, 5, 4, 3, 2]))
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
