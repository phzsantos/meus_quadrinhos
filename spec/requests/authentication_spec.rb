# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Authentication", type: :request) do
  let(:user) { create(:user, password: "123456") }

  describe "POST /users/sign_in" do
    context "com credenciais válidas" do
      it "loga o usuário e redireciona" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "123456",
          },
        }

        expect(response).to(redirect_to(root_path))
      end
    end

    context "com credenciais inválidas" do
      it "não loga o usuário" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "errada",
          },
        }

        expect(response.body).to(include("inválidos").or(include("Invalid")))
      end
    end
  end

  describe "DELETE /users/sign_out" do
    it "faz logout com sucesso" do
      sign_in user

      delete destroy_user_session_path

      expect(response).to(redirect_to(root_path))
    end
  end

  describe "POST /users (registro)" do
    it "cria um usuário com dados válidos" do
      expect do
        post(user_registration_path, params: {
          user: {
            username: "novo_user",
            email: "novo@test.com",
            password: "123456",
            password_confirmation: "123456",
          },
        })
      end.to(change(User, :count).by(1))
    end

    it "não cria usuário com dados inválidos" do
      expect do
        post(user_registration_path, params: {
          user: {
            username: "",
            email: "",
            password: "",
            password_confirmation: "",
          },
        })
      end.not_to(change(User, :count))
    end
  end

  describe "proteção de rotas" do
    it "redireciona para login se não estiver autenticado" do
      get authors_path

      expect(response).to(redirect_to(new_user_session_path))
    end

    it "permite acesso se estiver autenticado" do
      sign_in user

      get authors_path

      expect(response).to(have_http_status(:ok))
    end
  end
end
