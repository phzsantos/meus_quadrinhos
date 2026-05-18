# frozen_string_literal: true

require "rails_helper"

RSpec.describe("BookBindings", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /book_bindings" do
    before { sign_in user }

    it "retorna sucesso" do
      get book_bindings_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /book_bindings/:id" do
    before { sign_in user }

    it "retorna sucesso" do
      book_binding = create(:book_binding)

      get book_binding_path(book_binding)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /book_bindings/new" do
    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get new_book_binding_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get new_book_binding_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /book_bindings/:id/edit" do
    let(:book_binding) { create(:book_binding) }

    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get edit_book_binding_path(book_binding)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get edit_book_binding_path(book_binding)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /book_bindings" do
    context "como usuário comum" do
      before { sign_in user }

      it "não cria book binding" do
        expect do
          post(book_bindings_path, params: {
            book_binding: { name: "Hardcover" },
          })
        end.not_to(change(BookBinding, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

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
        it "não cria e renderiza new" do
          expect do
            post(book_bindings_path, params: {
              book_binding: { name: "" },
            })
          end.not_to(change(BookBinding, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /book_bindings/:id" do
    let(:book_binding) { create(:book_binding, name: "Old Binding") }

    context "como usuário comum" do
      before { sign_in user }

      it "não atualiza" do
        patch book_binding_path(book_binding), params: {
          book_binding: { name: "New Binding" },
        }

        expect(response).to(redirect_to(root_path))
        expect(book_binding.reload.name).to(eq("Old Binding"))
      end
    end

    context "como admin" do
      before { sign_in admin }

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
  end

  describe "DELETE /book_bindings/:id" do
    let!(:book_binding) { create(:book_binding) }

    context "como usuário comum" do
      before { sign_in user }

      it "não remove" do
        expect do
          delete(book_binding_path(book_binding))
        end.not_to(change(BookBinding, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "remove o book binding" do
        expect do
          delete(book_binding_path(book_binding))
        end.to(change(BookBinding, :count).by(-1))

        expect(response).to(redirect_to(book_bindings_path))
      end

      it "não remove o publisher quando tem quadrinhos associados" do
        create(:comic, book_binding: book_binding)

        expect do
          delete(book_binding_path(book_binding))
        end.not_to(change(BookBinding, :count))

        expect(response).to(redirect_to(book_bindings_path))
      end
    end
  end
end
