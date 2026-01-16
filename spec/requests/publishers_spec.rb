# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Publishers", type: :request) do
  describe "GET /publishers" do
    it "retorna sucesso" do
      get publishers_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publishers/:id" do
    it "retorna sucesso" do
      publisher = create(:publisher)

      get publisher_path(publisher)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publishers/new" do
    it "retorna sucesso" do
      get new_publisher_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publishers/:id/edit" do
    it "retorna sucesso" do
      publisher = create(:publisher)

      get edit_publisher_path(publisher)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "POST /publishers" do
    context "com parâmetros válidos" do
      it "cria um publisher" do
        expect do
          post(publishers_path, params: {
            publisher: { name: "DC Comics" },
          })
        end.to(change(Publisher, :count).by(1))

        expect(response).to(redirect_to(publisher_path(Publisher.last)))
      end
    end

    context "com parâmetros inválidos" do
      it "não cria publisher e renderiza new" do
        expect do
          post(publishers_path, params: {
            publisher: { name: "" },
          })
        end.not_to(change(Publisher, :count))

        expect(response).to(have_http_status(:unprocessable_content))
      end
    end
  end

  describe "PATCH /publishers/:id" do
    let(:publisher) { create(:publisher, name: "Old Publisher") }

    context "com parâmetros válidos" do
      it "atualiza o publisher" do
        patch publisher_path(publisher), params: {
          publisher: { name: "New Publisher" },
        }

        expect(response).to(redirect_to(publisher_path(publisher.reload)))
        expect(publisher.reload.name).to(eq("New Publisher"))
      end
    end

    context "com parâmetros inválidos" do
      it "não atualiza e renderiza edit" do
        patch publisher_path(publisher), params: {
          publisher: { name: "" },
        }

        expect(response).to(have_http_status(:unprocessable_content))
        expect(publisher.reload.name).to(eq("Old Publisher"))
      end
    end
  end

  describe "DELETE /publishers/:id" do
    it "remove o publisher" do
      publisher = create(:publisher)

      expect do
        delete(publisher_path(publisher))
      end.to(change(Publisher, :count).by(-1))

      expect(response).to(redirect_to(publishers_path))
    end
  end
end
