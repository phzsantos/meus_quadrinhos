# frozen_string_literal: true

require "rails_helper"

RSpec.describe("BookBindings", type: :request) do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /book_bindings" do
    it "retorna sucesso" do
      get book_bindings_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /book_bindings/:id" do
    it "retorna sucesso" do
      book_binding = create(:book_binding)

      get book_binding_path(book_binding)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /book_bindings/new" do
    it "retorna sucesso" do
      get new_book_binding_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /book_bindings/:id/edit" do
    it "retorna sucesso" do
      book_binding = create(:book_binding)

      get edit_book_binding_path(book_binding)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "POST /book_bindings" do
    context "com parâmetros válidos" do
      it "cria um book binding" do
        expect do
          post(book_bindings_path, params: {
            book_binding: { name: "Hardcover" },
          })
        end.to(change(BookBinding, :count).by(1))

        expect(response).to(redirect_to(book_binding_path(BookBinding.last)))
      end
    end

    context "com parâmetros inválidos" do
      it "não cria book binding e renderiza new" do
        expect do
          post(book_bindings_path, params: {
            book_binding: { name: "" },
          })
        end.not_to(change(BookBinding, :count))

        expect(response).to(have_http_status(:unprocessable_content))
      end
    end
  end

  describe "PATCH /book_bindings/:id" do
    let(:book_binding) { create(:book_binding, name: "Old Binding") }

    context "com parâmetros válidos" do
      it "atualiza o book binding" do
        patch book_binding_path(book_binding), params: {
          book_binding: { name: "New Binding" },
        }

        expect(response).to(redirect_to(book_binding_path(book_binding.reload)))
        expect(book_binding.reload.name).to(eq("New Binding"))
      end
    end

    context "com parâmetros inválidos" do
      it "não atualiza e renderiza edit" do
        patch book_binding_path(book_binding), params: {
          book_binding: { name: "" },
        }

        expect(response).to(have_http_status(:unprocessable_content))
        expect(book_binding.reload.name).to(eq("Old Binding"))
      end
    end
  end

  describe "DELETE /book_bindings/:id" do
    it "remove o book binding" do
      book_binding = create(:book_binding)

      expect do
        delete(book_binding_path(book_binding))
      end.to(change(BookBinding, :count).by(-1))

      expect(response).to(redirect_to(book_bindings_path))
    end
  end
end
