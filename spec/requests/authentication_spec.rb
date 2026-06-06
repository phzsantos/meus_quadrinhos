# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Authentication", type: :request) do
  let(:user) { create(:user, password: "123456") }

  describe "POST /users/sign_in" do
    context "with valid credentials" do
      it "logs in the user and redirects" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "123456",
          },
        }

        expect(response).to(redirect_to(root_path))
      end
    end

    context "with invalid credentials" do
      it "does not log in the user" do
        I18n.with_locale(:en) do
          post user_session_path, params: {
            user: {
              email: user.email,
              password: "wrong",
            },
          }

          expect(response.body).to(include("Invalid"))
        end
      end
    end
  end

  describe "DELETE /users/sign_out" do
    it "logs out successfully" do
      sign_in user

      delete destroy_user_session_path

      expect(response).to(redirect_to(root_path))
    end
  end

  describe "POST /users (registration)" do
    it "creates a user with valid data" do
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

    it "does not create a user with invalid data" do
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

  describe "route protection" do
    it "redirects to login when not authenticated" do
      get authors_path

      expect(response).to(redirect_to(new_user_session_path))
    end

    it "allows access when authenticated" do
      sign_in user

      get authors_path

      expect(response).to(have_http_status(:ok))
    end
  end
end
