# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Characters", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /characters" do
    before { sign_in user }

    it "returns success" do
      get characters_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /characters/:id" do
    before { sign_in user }

    it "returns success" do
      character = create(:character)

      get character_path(character)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /characters/new" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get new_character_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get new_character_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /characters/:id/edit" do
    let(:character) { create(:character) }

    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get edit_character_path(character)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get edit_character_path(character)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /characters" do
    context "as regular user" do
      before { sign_in user }

      it "does not create character" do
        expect do
          post(characters_path, params: {
            character: { name: "Bruce Wayne" },
          })
        end.not_to(change(Character, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "creates a character" do
          expect do
            post(characters_path, params: {
              character: { name: "Bruce Wayne" },
            })
          end.to(change(Character, :count).by(1))

          expect(response).to(redirect_to(character_path(Character.last)))
        end
      end

      context "with invalid parameters" do
        it "does not create and renders new" do
          expect do
            post(characters_path, params: {
              character: { name: "" },
            })
          end.not_to(change(Character, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create character with duplicate name" do
          create(:character, name: "Bruce Wayne")

          expect do
            post(characters_path, params: {
              character: { name: "Bruce Wayne" },
            })
          end.not_to(change(Character, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /characters/:id" do
    let(:character) { create(:character, name: "Old Name") }

    context "as regular user" do
      before { sign_in user }

      it "does not update" do
        patch character_path(character), params: {
          character: { name: "New Name" },
        }

        expect(response).to(redirect_to(root_path))
        expect(character.reload.name).to(eq("Old Name"))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "updates the character" do
          patch character_path(character), params: {
            character: { name: "New Name" },
          }

          expect(response).to(redirect_to(character_path(character.reload)))
          expect(character.reload.name).to(eq("New Name"))
        end
      end

      context "with invalid parameters" do
        it "does not update and renders edit" do
          patch character_path(character), params: {
            character: { name: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(character.reload.name).to(eq("Old Name"))
        end

        it "does not update with duplicate name" do
          create(:character, name: "Existing Name")

          patch character_path(character), params: {
            character: { name: "Existing Name" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(character.reload.name).to(eq("Old Name"))
        end
      end
    end
  end

  describe "DELETE /characters/:id" do
    let!(:character) { create(:character) }

    context "as regular user" do
      before { sign_in user }

      it "does not remove" do
        expect do
          delete(character_path(character))
        end.not_to(change(Character, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "removes the character" do
        expect do
          delete(character_path(character))
        end.to(change(Character, :count).by(-1))

        expect(response).to(redirect_to(characters_path))
      end

      it "does not remove character when it has associated comics" do
        create(:comic, characters: [character])

        expect do
          delete(character_path(character))
        end.not_to(change(Character, :count))

        expect(response).to(redirect_to(characters_path))
      end
    end
  end
end
