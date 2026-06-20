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
  end

  describe "GET /publishers/:id" do
    before { sign_in user }

    it "returns success" do
      publisher = create(:publisher)

      get publisher_path(publisher)
      expect(response).to(have_http_status(:ok))
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
end
