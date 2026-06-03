# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Collections", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /collections" do
    before { sign_in user }

    it "retorna sucesso" do
      get collections_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /collections/:id" do
    before { sign_in user }

    it "retorna sucesso" do
      collection = create(:collection)

      get collection_path(collection)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /collections/new" do
    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get new_collection_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get new_collection_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /collections/:id/edit" do
    let(:collection) { create(:collection) }

    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get edit_collection_path(collection)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get edit_collection_path(collection)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /collections" do
    context "como usuário comum" do
      before { sign_in user }

      it "não cria collection" do
        expect do
          post(collections_path, params: {
            collection: {
              name: "Tex Willer",
              link_guia_dos_quadrinhos: "https://www.guiadosquadrinhos.com/tex",
            },
          })
        end.not_to(change(Collection, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

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
        it "não cria e renderiza new" do
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

        it "não cria collection com nome duplicado" do
          create(:collection, name: "Justiceiro: Deluxe")

          expect do
            post(collections_path, params: {
              collection: { name: "Justiceiro: Deluxe" },
            })
          end.not_to(change(Collection, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
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

    context "como usuário comum" do
      before { sign_in user }

      it "não atualiza" do
        patch collection_path(collection), params: {
          collection: {
            name: "New Collection",
          },
        }

        expect(response).to(redirect_to(root_path))
        expect(collection.reload.name).to(eq("Old Collection"))
      end
    end

    context "como admin" do
      before { sign_in admin }

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

        it "não atualiza com nome duplicado" do
          create(:collection, name: "Justiceiro: Deluxe")

          patch collection_path(collection), params: {
            collection: { name: "Justiceiro: Deluxe" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(collection.reload.name).to(eq("Old Collection"))
        end
      end
    end
  end

  describe "DELETE /collections/:id" do
    let!(:collection) { create(:collection) }

    context "como usuário comum" do
      before { sign_in user }

      it "não remove" do
        expect do
          delete(collection_path(collection))
        end.not_to(change(Collection, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "remove a collection" do
        expect do
          delete(collection_path(collection))
        end.to(change(Collection, :count).by(-1))

        expect(response).to(redirect_to(collections_path))
      end

      it "remove a collection mesmo com quadrinhos associados" do
        create(:comic, collection:)

        expect do
          delete(collection_path(collection))
        end.to(change(Collection, :count).by(-1))

        expect(response).to(redirect_to(collections_path))
      end

      it "remove a collection e retira associação dos quadrinhos" do
        comic = create(:comic, collection: collection)

        delete(collection_path(collection))

        expect(comic.reload.collection).to(be_nil)
      end
    end
  end
end
