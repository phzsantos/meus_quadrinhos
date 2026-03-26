# frozen_string_literal: true

require "rails_helper"

RSpec.describe("PaperTypes", type: :request) do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /paper_types" do
    it "retorna sucesso" do
      get paper_types_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /paper_types/:id" do
    it "retorna sucesso" do
      paper_type = create(:paper_type)

      get paper_type_path(paper_type)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /paper_types/new" do
    it "retorna sucesso" do
      get new_paper_type_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /paper_types/:id/edit" do
    it "retorna sucesso" do
      paper_type = create(:paper_type)

      get edit_paper_type_path(paper_type)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "POST /paper_types" do
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
      it "não cria paper type e renderiza new" do
        expect do
          post(paper_types_path, params: {
            paper_type: { name: "" },
          })
        end.not_to(change(PaperType, :count))

        expect(response).to(have_http_status(:unprocessable_content))
      end
    end
  end

  describe "PATCH /paper_types/:id" do
    let(:paper_type) { create(:paper_type, name: "Old Paper") }

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

  describe "DELETE /paper_types/:id" do
    it "remove o paper type" do
      paper_type = create(:paper_type)

      expect do
        delete(paper_type_path(paper_type))
      end.to(change(PaperType, :count).by(-1))

      expect(response).to(redirect_to(paper_types_path))
    end
  end
end
