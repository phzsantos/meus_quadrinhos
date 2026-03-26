# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Authors", type: :request) do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /authors" do
    it "retorna sucesso" do
      get authors_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /authors/:id" do
    it "retorna sucesso" do
      author = create(:author)

      get author_path(author)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /authors/new" do
    it "retorna sucesso" do
      get new_author_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /authors/:id/edit" do
    it "retorna sucesso" do
      author = create(:author)

      get edit_author_path(author)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "POST /authors" do
    context "com parâmetros válidos" do
      it "cria um author" do
        expect do
          post(authors_path, params: {
            author: { name: "Alan Moore" },
          })
        end.to(change(Author, :count).by(1))

        expect(response).to(redirect_to(author_path(Author.last)))
      end
    end

    context "com parâmetros inválidos" do
      it "não cria author e renderiza new" do
        expect do
          post(authors_path, params: {
            author: { name: "" },
          })
        end.not_to(change(Author, :count))

        expect(response).to(have_http_status(:unprocessable_content))
      end
    end
  end

  describe "PATCH /authors/:id" do
    let(:author) { create(:author, name: "Old Name") }

    context "com parâmetros válidos" do
      it "atualiza o author" do
        patch author_path(author), params: {
          author: { name: "New Name" },
        }

        expect(response).to(redirect_to(author_path(author.reload)))
        expect(author.reload.name).to(eq("New Name"))
      end
    end

    context "com parâmetros inválidos" do
      it "não atualiza e renderiza edit" do
        patch author_path(author), params: {
          author: { name: "" },
        }

        expect(response).to(have_http_status(:unprocessable_content))
        expect(author.reload.name).to(eq("Old Name"))
      end
    end
  end

  describe "DELETE /authors/:id" do
    it "remove o author" do
      author = create(:author)

      expect do
        delete(author_path(author))
      end.to(change(Author, :count).by(-1))

      expect(response).to(redirect_to(authors_path))
    end
  end
end
