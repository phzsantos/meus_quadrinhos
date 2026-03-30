# frozen_string_literal: true

require "rails_helper"

RSpec.describe("PaperTypes", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /paper_types" do
    before { sign_in user }

    it "retorna sucesso" do
      get paper_types_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /paper_types/:id" do
    before { sign_in user }

    it "retorna sucesso" do
      paper_type = create(:paper_type)

      get paper_type_path(paper_type)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /paper_types/new" do
    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get new_paper_type_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get new_paper_type_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /paper_types/:id/edit" do
    let(:paper_type) { create(:paper_type) }

    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get edit_paper_type_path(paper_type)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get edit_paper_type_path(paper_type)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /paper_types" do
    context "como usuário comum" do
      before { sign_in user }

      it "não cria paper type" do
        expect do
          post(paper_types_path, params: {
            paper_type: { name: "Couché" },
          })
        end.not_to(change(PaperType, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      context "com parâmetros válidos" do
        it "cria um paper type" do
          expect do
            post(paper_types_path, params: {
              paper_type: { name: "Couché" },
            })
          end.to(change(PaperType, :count).by(1))

          expect(response).to(redirect_to(paper_type_path(PaperType.last)))
        end
      end

      context "com parâmetros inválidos" do
        it "não cria e renderiza new" do
          expect do
            post(paper_types_path, params: {
              paper_type: { name: "" },
            })
          end.not_to(change(PaperType, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /paper_types/:id" do
    let(:paper_type) { create(:paper_type, name: "Old Paper") }

    context "como usuário comum" do
      before { sign_in user }

      it "não atualiza" do
        patch paper_type_path(paper_type), params: {
          paper_type: { name: "New Paper" },
        }

        expect(response).to(redirect_to(root_path))
        expect(paper_type.reload.name).to(eq("Old Paper"))
      end
    end

    context "como admin" do
      before { sign_in admin }

      context "com parâmetros válidos" do
        it "atualiza o paper type" do
          patch paper_type_path(paper_type), params: {
            paper_type: { name: "New Paper" },
          }

          expect(response).to(redirect_to(paper_type_path(paper_type.reload)))
          expect(paper_type.reload.name).to(eq("New Paper"))
        end
      end

      context "com parâmetros inválidos" do
        it "não atualiza e renderiza edit" do
          patch paper_type_path(paper_type), params: {
            paper_type: { name: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(paper_type.reload.name).to(eq("Old Paper"))
        end
      end
    end
  end

  describe "DELETE /paper_types/:id" do
    let!(:paper_type) { create(:paper_type) }

    context "como usuário comum" do
      before { sign_in user }

      it "não remove" do
        expect do
          delete(paper_type_path(paper_type))
        end.not_to(change(PaperType, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "remove o paper type" do
        expect do
          delete(paper_type_path(paper_type))
        end.to(change(PaperType, :count).by(-1))

        expect(response).to(redirect_to(paper_types_path))
      end
    end
  end
end
