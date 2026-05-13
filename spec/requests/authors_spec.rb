# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Authors", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /authors" do
    before { sign_in user }

    it "retorna sucesso" do
      get authors_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /authors/:id" do
    before { sign_in user }

    it "retorna sucesso" do
      author = create(:author)

      get author_path(author)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /authors/new" do
    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get new_author_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get new_author_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /authors/:id/edit" do
    let(:author) { create(:author) }

    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get edit_author_path(author)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get edit_author_path(author)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /authors" do
    context "como usuário comum" do
      before { sign_in user }

      it "não cria author" do
        expect do
          post(authors_path, params: {
            author: { name: "Alan Moore" },
          })
        end.not_to(change(Author, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

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
  end

  describe "PATCH /authors/:id" do
    let(:author) { create(:author, name: "Old Name") }

    context "como usuário comum" do
      before { sign_in user }

      it "não atualiza" do
        patch author_path(author), params: {
          author: { name: "New Name" },
        }

        expect(response).to(redirect_to(root_path))
        expect(author.reload.name).to(eq("Old Name"))
      end
    end

    context "como admin" do
      before { sign_in admin }

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
  end

  describe "DELETE /authors/:id" do
    let!(:author) { create(:author) }

    context "como usuário comum" do
      before { sign_in user }

      it "não remove o author" do
        expect do
          delete(author_path(author))
        end.not_to(change(Author, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "remove o author" do
        expect do
          delete(author_path(author))
        end.to(change(Author, :count).by(-1))

        expect(response).to(redirect_to(authors_path))
      end

      it "não remove o author quando tem quadrinhos associados" do
        create(:comic, authors: [author])

        expect do
          delete(author_path(author))
        end.not_to(change(Author, :count))

        expect(response).to(redirect_to(authors_path))
      end
    end
  end
end
