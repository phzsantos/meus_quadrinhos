# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Publishers", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /publishers" do
    before { sign_in user }

    it "returns success" do
      get publishers_path
      expect(response).to(have_http_status(:ok))
    end

    it "lists only publishers with comics visible to the user" do
      visible_publisher = create(:publisher, name: "Visible Publisher")
      hidden_publisher = create(:publisher, name: "Hidden Publisher")
      visible_comic = create(:comic, publisher: visible_publisher, title: "Publisher Owned")
      create(:comic, publisher: hidden_publisher, title: "Publisher Hidden")
      create(:user_comic, user: user, comic: visible_comic)

      get publishers_path

      expect(response.body).to(include("Visible Publisher"))
      expect(response.body).not_to(include("Hidden Publisher"))
    end
  end

  describe "GET /publishers as admin" do
    before { sign_in admin }

    it "lists every publisher" do
      owned_publisher = create(:publisher, name: "Owned Publisher")
      create(:publisher, name: "Catalog Publisher")
      create(:publisher, name: "Unused Publisher")
      owned_comic = create(:comic, publisher: owned_publisher)
      create(:user_comic, user: admin, comic: owned_comic)

      get publishers_path

      expect(response.body).to(include("Owned Publisher"))
      expect(response.body).to(include("Catalog Publisher"))
      expect(response.body).to(include("Unused Publisher"))
    end
  end

  describe "GET /publishers/:id" do
    before { sign_in user }

    it "returns success" do
      publisher = create(:publisher)

      get publisher_path(publisher)
      expect(response).to(have_http_status(:ok))
    end

    it "shows only comics the user owns or has read" do
      publisher = create(:publisher, name: "Panini")
      owned_comic = create(:comic, publisher: publisher, title: "Owned By Publisher")
      read_comic = create(:comic, publisher: publisher, title: "Read By Publisher")
      hidden_comic = create(:comic, publisher: publisher, title: "Hidden By Publisher")
      create(:user_comic, user: user, comic: owned_comic)
      create(:reading, user: user, comic: read_comic)

      get publisher_path(publisher)

      expect(response.body).to(include(owned_comic.display_title))
      expect(response.body).to(include(read_comic.display_title))
      expect(response.body).not_to(include(hidden_comic.display_title))
    end
  end

  describe "GET /publishers/:id as admin" do
    before { sign_in admin }

    it "shows every comic of the publisher" do
      publisher = create(:publisher, name: "Panini")
      owned_comic = create(:comic, publisher: publisher, title: "Owned By Publisher")
      hidden_comic = create(:comic, publisher: publisher, title: "Hidden By Publisher")
      create(:user_comic, user: admin, comic: owned_comic)

      get publisher_path(publisher)

      expect(response.body).to(include(owned_comic.display_title))
      expect(response.body).to(include(hidden_comic.display_title))
    end
  end

  describe "GET /publishers/new" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get new_publisher_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get new_publisher_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /publishers/:id/edit" do
    let(:publisher) { create(:publisher) }

    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get edit_publisher_path(publisher)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get edit_publisher_path(publisher)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /publishers" do
    context "as regular user" do
      before { sign_in user }

      it "does not create publisher" do
        expect do
          post(publishers_path, params: {
            publisher: { name: "DC Comics" },
          })
        end.not_to(change(Publisher, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "creates a publisher" do
          expect do
            post(publishers_path, params: {
              publisher: { name: "DC Comics" },
            })
          end.to(change(Publisher, :count).by(1))

          expect(response).to(redirect_to(publisher_path(Publisher.last)))
        end
      end

      context "with invalid parameters" do
        it "does not create and renders new" do
          expect do
            post(publishers_path, params: {
              publisher: { name: "" },
            })
          end.not_to(change(Publisher, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /publishers/:id" do
    let(:publisher) { create(:publisher, name: "Old Publisher") }

    context "as regular user" do
      before { sign_in user }

      it "does not update" do
        patch publisher_path(publisher), params: {
          publisher: { name: "New Publisher" },
        }

        expect(response).to(redirect_to(root_path))
        expect(publisher.reload.name).to(eq("Old Publisher"))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "updates the publisher" do
          patch publisher_path(publisher), params: {
            publisher: { name: "New Publisher" },
          }

          expect(response).to(redirect_to(publisher_path(publisher.reload)))
          expect(publisher.reload.name).to(eq("New Publisher"))
        end
      end

      context "with invalid parameters" do
        it "does not update and renders edit" do
          patch publisher_path(publisher), params: {
            publisher: { name: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(publisher.reload.name).to(eq("Old Publisher"))
        end
      end
    end
  end

  describe "DELETE /publishers/:id" do
    let!(:publisher) { create(:publisher) }

    context "as regular user" do
      before { sign_in user }

      it "does not remove" do
        expect do
          delete(publisher_path(publisher))
        end.not_to(change(Publisher, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "removes the publisher" do
        expect do
          delete(publisher_path(publisher))
        end.to(change(Publisher, :count).by(-1))

        expect(response).to(redirect_to(publishers_path))
      end

      it "does not remove the publisher when it has associated comics" do
        create(:comic, publisher: publisher)

        expect do
          delete(publisher_path(publisher))
        end.not_to(change(Publisher, :count))

        expect(response).to(redirect_to(publishers_path))
      end
    end
  end

  describe "GET /publishers/export" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get export_publishers_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "exports publishers as JSON array of names" do
        create(:publisher, name: "Panini")
        create(:publisher, name: "Abril")

        get export_publishers_path

        expect(response).to(have_http_status(:ok))
        expect(response.parsed_body).to(eq(["Panini", "Abril"]))
      end
    end
  end
end
