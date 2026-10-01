# frozen_string_literal: true

require "rails_helper"

RSpec.describe("PaperTypes", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /paper_types" do
    before { sign_in user }

    it "returns success" do
      get paper_types_path
      expect(response).to(have_http_status(:ok))
    end

    it "lists only paper types with comics visible to the user" do
      visible_paper = create(:paper_type, name: "Visible Paper")
      hidden_paper = create(:paper_type, name: "Hidden Paper")
      visible_comic = create(:comic, paper_type: visible_paper, title: "Paper Owned")
      create(:comic, paper_type: hidden_paper, title: "Paper Hidden")
      create(:user_comic, user: user, comic: visible_comic)

      get paper_types_path

      expect(response.body).to(include("Visible Paper"))
      expect(response.body).not_to(include("Hidden Paper"))
    end
  end

  describe "GET /paper_types as admin" do
    before { sign_in admin }

    it "lists every paper type" do
      owned_paper = create(:paper_type, name: "Owned Paper")
      create(:paper_type, name: "Catalog Paper")
      create(:paper_type, name: "Unused Paper")
      owned_comic = create(:comic, paper_type: owned_paper)
      create(:user_comic, user: admin, comic: owned_comic)

      get paper_types_path

      expect(response.body).to(include("Owned Paper"))
      expect(response.body).to(include("Catalog Paper"))
      expect(response.body).to(include("Unused Paper"))
    end
  end

  describe "GET /paper_types/:id" do
    before { sign_in user }

    it "returns success" do
      paper_type = create(:paper_type)

      get paper_type_path(paper_type)
      expect(response).to(have_http_status(:ok))
    end

    it "shows only comics the user owns or has read" do
      paper_type = create(:paper_type, name: "Offset")
      owned_comic = create(:comic, paper_type: paper_type, title: "Owned By Paper")
      read_comic = create(:comic, paper_type: paper_type, title: "Read By Paper")
      hidden_comic = create(:comic, paper_type: paper_type, title: "Hidden By Paper")
      create(:user_comic, user: user, comic: owned_comic)
      create(:reading, user: user, comic: read_comic)

      get paper_type_path(paper_type)

      expect(response.body).to(include(owned_comic.display_title))
      expect(response.body).to(include(read_comic.display_title))
      expect(response.body).not_to(include(hidden_comic.display_title))
    end
  end

  describe "GET /paper_types/:id as admin" do
    before { sign_in admin }

    it "shows every comic of the paper type" do
      paper_type = create(:paper_type, name: "Offset")
      owned_comic = create(:comic, paper_type: paper_type, title: "Owned By Paper")
      hidden_comic = create(:comic, paper_type: paper_type, title: "Hidden By Paper")
      create(:user_comic, user: admin, comic: owned_comic)

      get paper_type_path(paper_type)

      expect(response.body).to(include(owned_comic.display_title))
      expect(response.body).to(include(hidden_comic.display_title))
    end
  end

  describe "GET /paper_types/new" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get new_paper_type_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get new_paper_type_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /paper_types/:id/edit" do
    let(:paper_type) { create(:paper_type) }

    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get edit_paper_type_path(paper_type)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get edit_paper_type_path(paper_type)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /paper_types" do
    context "as regular user" do
      before { sign_in user }

      it "does not create paper type" do
        expect do
          post(paper_types_path, params: {
            paper_type: { name: "Couché" },
          })
        end.not_to(change(PaperType, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "creates a paper type" do
          expect do
            post(paper_types_path, params: {
              paper_type: { name: "Couché" },
            })
          end.to(change(PaperType, :count).by(1))

          expect(response).to(redirect_to(paper_type_path(PaperType.last)))
        end
      end

      context "with invalid parameters" do
        it "does not create and renders new" do
          expect do
            post(paper_types_path, params: {
              paper_type: { name: "" },
            })
          end.not_to(change(PaperType, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /paper_types/:id" do
    let(:paper_type) { create(:paper_type, name: "Old Paper") }

    context "as regular user" do
      before { sign_in user }

      it "does not update" do
        patch paper_type_path(paper_type), params: {
          paper_type: { name: "New Paper" },
        }

        expect(response).to(redirect_to(root_path))
        expect(paper_type.reload.name).to(eq("Old Paper"))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "updates the paper type" do
          patch paper_type_path(paper_type), params: {
            paper_type: { name: "New Paper" },
          }

          expect(response).to(redirect_to(paper_type_path(paper_type.reload)))
          expect(paper_type.reload.name).to(eq("New Paper"))
        end
      end

      context "with invalid parameters" do
        it "does not update and renders edit" do
          patch paper_type_path(paper_type), params: {
            paper_type: { name: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(paper_type.reload.name).to(eq("Old Paper"))
        end
      end
    end
  end

  describe "DELETE /paper_types/:id" do
    let!(:paper_type) { create(:paper_type) }

    context "as regular user" do
      before { sign_in user }

      it "does not remove" do
        expect do
          delete(paper_type_path(paper_type))
        end.not_to(change(PaperType, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "removes the paper type" do
        expect do
          delete(paper_type_path(paper_type))
        end.to(change(PaperType, :count).by(-1))

        expect(response).to(redirect_to(paper_types_path))
      end

      it "does not remove the paper type when it has associated comics" do
        create(:comic, paper_type: paper_type)

        expect do
          delete(paper_type_path(paper_type))
        end.not_to(change(PaperType, :count))

        expect(response).to(redirect_to(paper_types_path))
      end
    end
  end

  describe "GET /paper_types/export" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get export_paper_types_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "exports paper types as JSON array of names" do
        create(:paper_type, name: "Offset")
        create(:paper_type, name: "Couché")

        get export_paper_types_path

        expect(response).to(have_http_status(:ok))
        expect(response.parsed_body).to(eq(["Offset", "Couché"]))
      end
    end
  end
end
