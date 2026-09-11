# frozen_string_literal: true

require "rails_helper"

RSpec.describe("BookBindings", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /book_bindings" do
    before { sign_in user }

    it "returns success" do
      get book_bindings_path
      expect(response).to(have_http_status(:ok))
    end

    it "lists only book bindings with comics visible to the user" do
      visible_binding = create(:book_binding, name: "Visible Binding")
      hidden_binding = create(:book_binding, name: "Hidden Binding")
      visible_comic = create(:comic, book_binding: visible_binding, title: "Binding Owned")
      create(:comic, book_binding: hidden_binding, title: "Binding Hidden")
      create(:user_comic, user: user, comic: visible_comic)

      get book_bindings_path

      expect(response.body).to(include("Visible Binding"))
      expect(response.body).not_to(include("Hidden Binding"))
    end
  end

  describe "GET /book_bindings/:id" do
    before { sign_in user }

    it "returns success" do
      book_binding = create(:book_binding)

      get book_binding_path(book_binding)
      expect(response).to(have_http_status(:ok))
    end

    it "shows only comics the user owns or has read" do
      book_binding = create(:book_binding, name: "Capa Dura")
      owned_comic = create(:comic, book_binding: book_binding, title: "Owned By Binding")
      read_comic = create(:comic, book_binding: book_binding, title: "Read By Binding")
      hidden_comic = create(:comic, book_binding: book_binding, title: "Hidden By Binding")
      create(:user_comic, user: user, comic: owned_comic)
      create(:reading, user: user, comic: read_comic)

      get book_binding_path(book_binding)

      expect(response.body).to(include(owned_comic.display_title))
      expect(response.body).to(include(read_comic.display_title))
      expect(response.body).not_to(include(hidden_comic.display_title))
    end
  end

  describe "GET /book_bindings/new" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get new_book_binding_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get new_book_binding_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /book_bindings/:id/edit" do
    let(:book_binding) { create(:book_binding) }

    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get edit_book_binding_path(book_binding)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get edit_book_binding_path(book_binding)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /book_bindings" do
    context "as regular user" do
      before { sign_in user }

      it "does not create book binding" do
        expect do
          post(book_bindings_path, params: {
            book_binding: { name: "Hardcover" },
          })
        end.not_to(change(BookBinding, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "creates a book binding" do
          expect do
            post(book_bindings_path, params: {
              book_binding: { name: "Hardcover" },
            })
          end.to(change(BookBinding, :count).by(1))

          expect(response).to(redirect_to(book_binding_path(BookBinding.last)))
        end
      end

      context "with invalid parameters" do
        it "does not create and renders new" do
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

    context "as regular user" do
      before { sign_in user }

      it "does not update" do
        patch book_binding_path(book_binding), params: {
          book_binding: { name: "New Binding" },
        }

        expect(response).to(redirect_to(root_path))
        expect(book_binding.reload.name).to(eq("Old Binding"))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "updates the book binding" do
          patch book_binding_path(book_binding), params: {
            book_binding: { name: "New Binding" },
          }

          expect(response).to(redirect_to(book_binding_path(book_binding.reload)))
          expect(book_binding.reload.name).to(eq("New Binding"))
        end
      end

      context "with invalid parameters" do
        it "does not update and renders edit" do
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

    context "as regular user" do
      before { sign_in user }

      it "does not remove" do
        expect do
          delete(book_binding_path(book_binding))
        end.not_to(change(BookBinding, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "removes the book binding" do
        expect do
          delete(book_binding_path(book_binding))
        end.to(change(BookBinding, :count).by(-1))

        expect(response).to(redirect_to(book_bindings_path))
      end

      it "does not remove the book binding when it has associated comics" do
        create(:comic, book_binding: book_binding)

        expect do
          delete(book_binding_path(book_binding))
        end.not_to(change(BookBinding, :count))

        expect(response).to(redirect_to(book_bindings_path))
      end
    end
  end

  describe "GET /book_bindings/export" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get export_book_bindings_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "exports book bindings as JSON array of names" do
        create(:book_binding, name: "Omnibus")
        create(:book_binding, name: "Capa dura")

        get export_book_bindings_path

        expect(response).to(have_http_status(:ok))
        expect(response.parsed_body).to(eq(["Omnibus", "Capa dura"]))
      end
    end
  end
end
