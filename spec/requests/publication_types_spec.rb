# frozen_string_literal: true

require "rails_helper"

RSpec.describe("PublicationTypes", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /publication_types" do
    before { sign_in user }

    it "retorna sucesso" do
      get publication_types_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publication_types/:id" do
    before { sign_in user }

    it "retorna sucesso" do
      publication_type = create(:publication_type)

      get publication_type_path(publication_type)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publication_types/new" do
    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get new_publication_type_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get new_publication_type_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /publication_types/:id/edit" do
    let(:publication_type) { create(:publication_type) }

    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get edit_publication_type_path(publication_type)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get edit_publication_type_path(publication_type)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /publication_types" do
    context "como usuário comum" do
      before { sign_in user }

      it "não cria publication type" do
        expect do
          post(publication_types_path, params: {
            publication_type: { name: "Graphic Novel" },
          })
        end.not_to(change(PublicationType, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      context "com parâmetros válidos" do
        it "cria um publication type" do
          expect do
            post(publication_types_path, params: {
              publication_type: { name: "Graphic Novel" },
            })
          end.to(change(PublicationType, :count).by(1))

          expect(response).to(redirect_to(publication_type_path(PublicationType.last)))
        end
      end

      context "com parâmetros inválidos" do
        it "não cria e renderiza new" do
          expect do
            post(publication_types_path, params: {
              publication_type: { name: "" },
            })
          end.not_to(change(PublicationType, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /publication_types/:id" do
    let(:publication_type) { create(:publication_type, name: "Old Type") }

    context "como usuário comum" do
      before { sign_in user }

      it "não atualiza" do
        patch publication_type_path(publication_type), params: {
          publication_type: { name: "New Type" },
        }

        expect(response).to(redirect_to(root_path))
        expect(publication_type.reload.name).to(eq("Old Type"))
      end
    end

    context "como admin" do
      before { sign_in admin }

      context "com parâmetros válidos" do
        it "atualiza o publication type" do
          patch publication_type_path(publication_type), params: {
            publication_type: { name: "New Type" },
          }

          expect(response).to(redirect_to(publication_type_path(publication_type.reload)))
          expect(publication_type.reload.name).to(eq("New Type"))
        end
      end

      context "com parâmetros inválidos" do
        it "não atualiza e renderiza edit" do
          patch publication_type_path(publication_type), params: {
            publication_type: { name: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(publication_type.reload.name).to(eq("Old Type"))
        end
      end
    end
  end

  describe "DELETE /publication_types/:id" do
    let!(:publication_type) { create(:publication_type) }

    context "como usuário comum" do
      before { sign_in user }

      it "não remove" do
        expect do
          delete(publication_type_path(publication_type))
        end.not_to(change(PublicationType, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "remove o publication type" do
        expect do
          delete(publication_type_path(publication_type))
        end.to(change(PublicationType, :count).by(-1))

        expect(response).to(redirect_to(publication_types_path))
      end

      it "não remove o publication type quando tem quadrinhos associados" do
        create(:comic, publication_type: publication_type)

        expect do
          delete(publication_type_path(publication_type))
        end.not_to(change(PublicationType, :count))

        expect(response).to(redirect_to(publication_types_path))
      end
    end
  end
end
