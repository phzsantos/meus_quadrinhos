# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Publishers", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /publishers" do
    before { sign_in user }

    it "retorna sucesso" do
      get publishers_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publishers/:id" do
    before { sign_in user }

    it "retorna sucesso" do
      publisher = create(:publisher)

      get publisher_path(publisher)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /publishers/new" do
    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get new_publisher_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get new_publisher_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /publishers/:id/edit" do
    let(:publisher) { create(:publisher) }

    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get edit_publisher_path(publisher)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get edit_publisher_path(publisher)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /publishers" do
    context "como usuário comum" do
      before { sign_in user }

      it "não cria publisher" do
        expect do
          post(publishers_path, params: {
            publisher: { name: "DC Comics" },
          })
        end.not_to(change(Publisher, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      context "com parâmetros válidos" do
        it "cria um publisher" do
          expect do
            post(publishers_path, params: {
              publisher: { name: "DC Comics" },
            })
          end.to(change(Publisher, :count).by(1))

          expect(response).to(redirect_to(publisher_path(Publisher.last)))
        end
      end

      context "com parâmetros inválidos" do
        it "não cria e renderiza new" do
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

    context "como usuário comum" do
      before { sign_in user }

      it "não atualiza" do
        patch publisher_path(publisher), params: {
          publisher: { name: "New Publisher" },
        }

        expect(response).to(redirect_to(root_path))
        expect(publisher.reload.name).to(eq("Old Publisher"))
      end
    end

    context "como admin" do
      before { sign_in admin }

      context "com parâmetros válidos" do
        it "atualiza o publisher" do
          patch publisher_path(publisher), params: {
            publisher: { name: "New Publisher" },
          }

          expect(response).to(redirect_to(publisher_path(publisher.reload)))
          expect(publisher.reload.name).to(eq("New Publisher"))
        end
      end

      context "com parâmetros inválidos" do
        it "não atualiza e renderiza edit" do
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

    context "como usuário comum" do
      before { sign_in user }

      it "não remove" do
        expect do
          delete(publisher_path(publisher))
        end.not_to(change(Publisher, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "remove o publisher" do
        expect do
          delete(publisher_path(publisher))
        end.to(change(Publisher, :count).by(-1))

        expect(response).to(redirect_to(publishers_path))
      end

      it "não remove o publisher quando tem quadrinhos associados" do
        create(:comic, publisher: publisher)

        expect do
          delete(publisher_path(publisher))
        end.not_to(change(Publisher, :count))

        expect(response).to(redirect_to(publishers_path))
      end
    end
  end
end
