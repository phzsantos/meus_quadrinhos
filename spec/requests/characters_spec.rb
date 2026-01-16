# frozen_string_literal: true

# spec/requests/characters_spec.rb
require "rails_helper"

RSpec.describe("Characters", type: :request) do
  describe "GET /characters" do
    it "retorna sucesso" do
      get characters_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /characters/:id" do
    it "retorna sucesso" do
      character = create(:character)

      get character_path(character)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /characters/new" do
    it "retorna sucesso" do
      get new_character_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /characters/:id/edit" do
    it "retorna sucesso" do
      character = create(:character)

      get edit_character_path(character)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "POST /characters" do
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
      it "não cria character e renderiza new" do
        expect do
          post(characters_path, params: {
            character: { name: "" },
          })
        end.not_to(change(Character, :count))

        expect(response).to(have_http_status(:unprocessable_content))
      end
    end
  end

  describe "PATCH /characters/:id" do
    let(:character) { create(:character, name: "Old Name") }

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

  describe "DELETE /characters/:id" do
    it "remove o character" do
      character = create(:character)

      expect do
        delete(character_path(character))
      end.to(change(Character, :count).by(-1))

      expect(response).to(redirect_to(characters_path))
    end
  end
end
