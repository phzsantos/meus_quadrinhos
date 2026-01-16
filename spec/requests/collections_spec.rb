# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Collections", type: :request) do
  describe "GET /collections" do
    it "retorna sucesso" do
      get collections_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /collections/:id" do
    it "retorna sucesso" do
      collection = create(:collection)

      get collection_path(collection)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /collections/new" do
    it "retorna sucesso" do
      get new_collection_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /collections/:id/edit" do
    it "retorna sucesso" do
      collection = create(:collection)

      get edit_collection_path(collection)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "POST /collections" do
    context "com parâmetros válidos" do
      it "cria uma collection" do
        expect do
          post(collections_path, params: {
            collection: {
              name: "Tex Willer",
              link_guia_dos_quadrinhos: "https://www.guiadosquadrinhos.com/tex",
            },
          })
        end.to(change(Collection, :count).by(1))

        expect(response).to(redirect_to(collection_path(Collection.last)))
      end
    end

    context "com parâmetros inválidos" do
      it "não cria a collection e renderiza new" do
        expect do
          post(collections_path, params: {
            collection: {
              name: "",
              link_guia_dos_quadrinhos: "",
            },
          })
        end.not_to(change(Collection, :count))

        expect(response).to(have_http_status(:unprocessable_content))
      end
    end
  end

  describe "PATCH /collections/:id" do
    let(:collection) do
      create(
        :collection,
        name: "Old Collection",
        link_guia_dos_quadrinhos: "https://old-link.com",
      )
    end

    context "com parâmetros válidos" do
      it "atualiza a collection" do
        patch collection_path(collection), params: {
          collection: {
            name: "New Collection",
            link_guia_dos_quadrinhos: "https://new-link.com",
          },
        }

        expect(response).to(redirect_to(collection_path(collection.reload)))
        expect(collection.reload.name).to(eq("New Collection"))
        expect(collection.link_guia_dos_quadrinhos).to(eq("https://new-link.com"))
      end
    end

    context "com parâmetros inválidos" do
      it "não atualiza e renderiza edit" do
        patch collection_path(collection), params: {
          collection: {
            name: "",
          },
        }

        expect(response).to(have_http_status(:unprocessable_content))
        expect(collection.reload.name).to(eq("Old Collection"))
      end
    end
  end

  describe "DELETE /collections/:id" do
    it "remove a collection" do
      collection = create(:collection)

      expect do
        delete(collection_path(collection))
      end.to(change(Collection, :count).by(-1))

      expect(response).to(redirect_to(collections_path))
    end
  end
end
