# frozen_string_literal: true

require "rails_helper"

RSpec.describe("PublicationTypes", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /publication_types" do
    before { sign_in user }

    it "returns success" do
      get publication_types_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publication_types/:id" do
    before { sign_in user }

    it "returns success" do
      publication_type = create(:publication_type)

      get publication_type_path(publication_type)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publication_types/new" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get new_publication_type_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get new_publication_type_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /publication_types/:id/edit" do
    let(:publication_type) { create(:publication_type) }

    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get edit_publication_type_path(publication_type)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get edit_publication_type_path(publication_type)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /publication_types" do
    context "as regular user" do
      before { sign_in user }

      it "does not create publication type" do
        expect do
          post(publication_types_path, params: {
            publication_type: { name: "Graphic Novel" },
          })
        end.not_to(change(PublicationType, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "creates a publication type" do
          expect do
            post(publication_types_path, params: {
              publication_type: { name: "Graphic Novel" },
            })
          end.to(change(PublicationType, :count).by(1))

          expect(response).to(redirect_to(publication_type_path(PublicationType.last)))
        end
      end

      context "with invalid parameters" do
        it "does not create and renders new" do
          expect do
            post(publication_types_path, params: {
              publication_type: { name: "" },
            })
          end.not_to(change(PublicationType, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /publication_types/:id" do
    let(:publication_type) { create(:publication_type, name: "Old Type") }

    context "as regular user" do
      before { sign_in user }

      it "does not update" do
        patch publication_type_path(publication_type), params: {
          publication_type: { name: "New Type" },
        }

        expect(response).to(redirect_to(root_path))
        expect(publication_type.reload.name).to(eq("Old Type"))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "updates the publication type" do
          patch publication_type_path(publication_type), params: {
            publication_type: { name: "New Type" },
          }

          expect(response).to(redirect_to(publication_type_path(publication_type.reload)))
          expect(publication_type.reload.name).to(eq("New Type"))
        end
      end

      context "with invalid parameters" do
        it "does not update and renders edit" do
          patch publication_type_path(publication_type), params: {
            publication_type: { name: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(publication_type.reload.name).to(eq("Old Type"))
        end
      end
    end
  end

  describe "DELETE /publication_types/:id" do
    let!(:publication_type) { create(:publication_type) }

    context "as regular user" do
      before { sign_in user }

      it "does not remove" do
        expect do
          delete(publication_type_path(publication_type))
        end.not_to(change(PublicationType, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "removes the publication type" do
        expect do
          delete(publication_type_path(publication_type))
        end.to(change(PublicationType, :count).by(-1))

        expect(response).to(redirect_to(publication_types_path))
      end

      it "does not remove the publication type when it has associated comics" do
        create(:comic, publication_type: publication_type)

        expect do
          delete(publication_type_path(publication_type))
        end.not_to(change(PublicationType, :count))

        expect(response).to(redirect_to(publication_types_path))
      end
    end
  end

  describe "GET /publication_types/export" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get export_publication_types_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "exports publication types as JSON array of names" do
        create(:publication_type, name: "Mangá")
        create(:publication_type, name: "HQ")

        get export_publication_types_path

        expect(response).to(have_http_status(:ok))
        expect(response.parsed_body).to(eq(["Mangá", "HQ"]))
      end
    end
  end
end
