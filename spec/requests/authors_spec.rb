# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Authors", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /authors" do
    before { sign_in user }

    it "returns success" do
      get authors_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /authors/:id" do
    before { sign_in user }

    it "returns success" do
      author = create(:author)

      get author_path(author)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /authors/new" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get new_author_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get new_author_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /authors/:id/edit" do
    let(:author) { create(:author) }

    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get edit_author_path(author)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get edit_author_path(author)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /authors" do
    context "as regular user" do
      before { sign_in user }

      it "does not create author" do
        expect do
          post(authors_path, params: {
            author: { name: "Alan Moore" },
          })
        end.not_to(change(Author, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "creates an author" do
          expect do
            post(authors_path, params: {
              author: { name: "Alan Moore" },
            })
          end.to(change(Author, :count).by(1))

          expect(response).to(redirect_to(author_path(Author.last)))
        end
      end

      context "with invalid parameters" do
        it "does not create author and renders new" do
          expect do
            post(authors_path, params: {
              author: { name: "" },
            })
          end.not_to(change(Author, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create author with duplicate name" do
          create(:author, name: "Alan Moore")

          expect do
            post(authors_path, params: {
              author: { name: "Alan Moore" },
            })
          end.not_to(change(Author, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /authors/:id" do
    let(:author) { create(:author, name: "Old Name") }

    context "as regular user" do
      before { sign_in user }

      it "does not update" do
        patch author_path(author), params: {
          author: { name: "New Name" },
        }

        expect(response).to(redirect_to(root_path))
        expect(author.reload.name).to(eq("Old Name"))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "updates the author" do
          patch author_path(author), params: {
            author: { name: "New Name" },
          }

          expect(response).to(redirect_to(author_path(author.reload)))
          expect(author.reload.name).to(eq("New Name"))
        end
      end

      context "with invalid parameters" do
        it "does not update and renders edit" do
          patch author_path(author), params: {
            author: { name: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(author.reload.name).to(eq("Old Name"))
        end

        it "does not update with duplicate name" do
          create(:author, name: "Existing Name")

          patch author_path(author), params: {
            author: { name: "Existing Name" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(author.reload.name).to(eq("Old Name"))
        end
      end
    end
  end

  describe "DELETE /authors/:id" do
    let!(:author) { create(:author) }

    context "as regular user" do
      before { sign_in user }

      it "does not remove the author" do
        expect do
          delete(author_path(author))
        end.not_to(change(Author, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "removes the author" do
        expect do
          delete(author_path(author))
        end.to(change(Author, :count).by(-1))

        expect(response).to(redirect_to(authors_path))
      end

      it "does not remove the author when it has associated comics" do
        create(:comic, authors: [author])

        expect do
          delete(author_path(author))
        end.not_to(change(Author, :count))

        expect(response).to(redirect_to(authors_path))
      end
    end
  end

  describe "GET /authors/export" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get export_authors_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "exports authors as JSON array of names" do
        create(:author, name: "Frank Miller")
        create(:author, name: "Alan Moore")

        get export_authors_path

        expect(response).to(have_http_status(:ok))
        expect(response.parsed_body).to(eq(["Frank Miller", "Alan Moore"]))
      end
    end
  end
end
