# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Characters", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /characters" do
    before { sign_in user }

    it "retorna sucesso" do
      get characters_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /characters/:id" do
    before { sign_in user }

    it "retorna sucesso" do
      character = create(:character)

      get character_path(character)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /characters/new" do
    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get new_character_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get new_character_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /characters/:id/edit" do
    let(:character) { create(:character) }

    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get edit_character_path(character)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get edit_character_path(character)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /characters" do
    context "como usuário comum" do
      before { sign_in user }

      it "não cria character" do
        expect do
          post(characters_path, params: {
            character: { name: "Bruce Wayne" },
          })
        end.not_to(change(Character, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      context "com parâmetros válidos" do
        it "cria um character" do
          expect do
            post(characters_path, params: {
              character: { name: "Bruce Wayne" },
            })
          end.to(change(Character, :count).by(1))

          expect(response).to(redirect_to(character_path(Character.last)))
        end
      end

      context "com parâmetros inválidos" do
        it "não cria e renderiza new" do
          expect do
            post(characters_path, params: {
              character: { name: "" },
            })
          end.not_to(change(Character, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /characters/:id" do
    let(:character) { create(:character, name: "Old Name") }

    context "como usuário comum" do
      before { sign_in user }

      it "não atualiza" do
        patch character_path(character), params: {
          character: { name: "New Name" },
        }

        expect(response).to(redirect_to(root_path))
        expect(character.reload.name).to(eq("Old Name"))
      end
    end

    context "como admin" do
      before { sign_in admin }

      context "com parâmetros válidos" do
        it "atualiza o character" do
          patch character_path(character), params: {
            character: { name: "New Name" },
          }

          expect(response).to(redirect_to(character_path(character.reload)))
          expect(character.reload.name).to(eq("New Name"))
        end
      end

      context "com parâmetros inválidos" do
        it "não atualiza e renderiza edit" do
          patch character_path(character), params: {
            character: { name: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(character.reload.name).to(eq("Old Name"))
        end
      end
    end
  end

  describe "DELETE /characters/:id" do
    let!(:character) { create(:character) }

    context "como usuário comum" do
      before { sign_in user }

      it "não remove" do
        expect do
          delete(character_path(character))
        end.not_to(change(Character, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "remove o character" do
        expect do
          delete(character_path(character))
        end.to(change(Character, :count).by(-1))

        expect(response).to(redirect_to(characters_path))
      end
    end
  end
end
