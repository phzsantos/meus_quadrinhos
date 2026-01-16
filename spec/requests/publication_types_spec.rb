# frozen_string_literal: true

require "rails_helper"

RSpec.describe("PublicationTypes", type: :request) do
  describe "GET /publication_types" do
    it "retorna sucesso" do
      get publication_types_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publication_types/:id" do
    it "retorna sucesso" do
      publication_type = create(:publication_type)

      get publication_type_path(publication_type)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publication_types/new" do
    it "retorna sucesso" do
      get new_publication_type_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publication_types/:id/edit" do
    it "retorna sucesso" do
      publication_type = create(:publication_type)

      get edit_publication_type_path(publication_type)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "POST /publication_types" do
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
      it "não cria publication type e renderiza new" do
        expect do
          post(publication_types_path, params: {
            publication_type: { name: "" },
          })
        end.not_to(change(PublicationType, :count))

        expect(response).to(have_http_status(:unprocessable_content))
      end
    end
  end

  describe "PATCH /publication_types/:id" do
    let(:publication_type) { create(:publication_type, name: "Old Type") }

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

  describe "DELETE /publication_types/:id" do
    it "remove o publication type" do
      publication_type = create(:publication_type)

      expect do
        delete(publication_type_path(publication_type))
      end.to(change(PublicationType, :count).by(-1))

      expect(response).to(redirect_to(publication_types_path))
    end
  end
end
