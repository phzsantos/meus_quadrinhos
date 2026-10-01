# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Collections", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /collections" do
    before { sign_in user }

    it "returns success" do
      get collections_path
      expect(response).to(have_http_status(:ok))
    end

    it "lists only collections with comics visible to the user" do
      visible_collection = create(:collection, name: "Visible Collection")
      hidden_collection = create(:collection, name: "Hidden Collection")
      visible_comic = create(:comic, collection: visible_collection, title: "Visible Title")
      create(:comic, collection: hidden_collection, title: "Hidden Title")
      create(:user_comic, user: user, comic: visible_comic)

      get collections_path

      expect(response.body).to(include("Visible Collection"))
      expect(response.body).not_to(include("Hidden Collection"))
    end
  end

  describe "GET /collections as admin" do
    before { sign_in admin }

    it "lists every collection" do
      owned_collection = create(:collection, name: "Owned Collection")
      create(:collection, name: "Catalog Collection")
      create(:collection, name: "Unused Collection")
      owned_comic = create(:comic, collection: owned_collection)
      create(:user_comic, user: admin, comic: owned_comic)

      get collections_path

      expect(response.body).to(include("Owned Collection"))
      expect(response.body).to(include("Catalog Collection"))
      expect(response.body).to(include("Unused Collection"))
    end
  end

  describe "GET /collections/:id" do
    before { sign_in user }

    it "returns success" do
      collection = create(:collection)

      get collection_path(collection)
      expect(response).to(have_http_status(:ok))
    end

    it "shows only comics the user owns or has read" do
      collection = create(:collection, name: "Batman")
      owned_comic = create(:comic, collection: collection, title: "Owned Volume", issue_number: 1)
      read_comic = create(:comic, collection: collection, title: "Read Volume", issue_number: 2)
      hidden_comic = create(:comic, collection: collection, title: "Hidden Volume", issue_number: 3)
      create(:user_comic, user: user, comic: owned_comic)
      create(:reading, user: user, comic: read_comic)

      get collection_path(collection)

      expect(response.body).to(include(owned_comic.display_title))
      expect(response.body).to(include(read_comic.display_title))
      expect(response.body).not_to(include(hidden_comic.display_title))
      expect(response.body).to(include("Total de volumes da coleção:</strong> 2"))
    end
  end

  describe "GET /collections/:id as admin" do
    before { sign_in admin }

    it "shows every comic of the collection" do
      collection = create(:collection, name: "Batman")
      owned_comic = create(:comic, collection: collection, title: "Owned Volume", issue_number: 1)
      hidden_comic = create(:comic, collection: collection, title: "Hidden Volume", issue_number: 2)
      create(:user_comic, user: admin, comic: owned_comic)

      get collection_path(collection)

      expect(response.body).to(include(owned_comic.display_title))
      expect(response.body).to(include(hidden_comic.display_title))
      expect(response.body).to(include("Total de volumes da coleção:</strong> 2"))
    end
  end

  describe "GET /collections/new" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get new_collection_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get new_collection_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /collections/:id/edit" do
    let(:collection) { create(:collection) }

    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get edit_collection_path(collection)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get edit_collection_path(collection)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /collections" do
    context "as regular user" do
      before { sign_in user }

      it "does not create collection" do
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

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "creates a collection" do
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

      context "with invalid parameters" do
        it "does not create and renders new" do
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

        it "does not create collection with duplicate name" do
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

    context "as regular user" do
      before { sign_in user }

      it "does not update" do
        patch collection_path(collection), params: {
          collection: {
            name: "New Collection",
          },
        }

        expect(response).to(redirect_to(root_path))
        expect(collection.reload.name).to(eq("Old Collection"))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "updates the collection" do
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

      context "with invalid parameters" do
        it "does not update and renders edit" do
          patch collection_path(collection), params: {
            collection: {
              name: "",
            },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(collection.reload.name).to(eq("Old Collection"))
        end

        it "does not update with duplicate name" do
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

    context "as regular user" do
      before { sign_in user }

      it "does not remove" do
        expect do
          delete(collection_path(collection))
        end.not_to(change(Collection, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "removes the collection" do
        expect do
          delete(collection_path(collection))
        end.to(change(Collection, :count).by(-1))

        expect(response).to(redirect_to(collections_path))
      end

      it "removes the collection even with associated comics" do
        create(:comic, collection:)

        expect do
          delete(collection_path(collection))
        end.to(change(Collection, :count).by(-1))

        expect(response).to(redirect_to(collections_path))
      end

      it "removes the collection and clears comics association" do
        comic = create(:comic, collection: collection)

        delete(collection_path(collection))

        expect(comic.reload.collection).to(be_nil)
      end
    end
  end

  describe "GET /collections/export" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get export_collections_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "exports collections as JSON in seed format" do
        create(
          :collection,
          name: "Justiceiro 3ª Série",
          link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/justiceiro-3-serie/ju011300",
        )
        create(
          :collection,
          name: "Absolute Batman",
          link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/absolute-batman/ab011101",
        )

        get export_collections_path

        expect(response).to(have_http_status(:ok))
        expect(response.parsed_body).to(eq([
          {
            "name" => "Justiceiro 3ª Série",
            "link_guia_dos_quadrinhos" => "http://www.guiadosquadrinhos.com/capas/justiceiro-3-serie/ju011300",
          },
          {
            "name" => "Absolute Batman",
            "link_guia_dos_quadrinhos" => "http://www.guiadosquadrinhos.com/capas/absolute-batman/ab011101",
          },
        ]))
      end
    end
  end
end
