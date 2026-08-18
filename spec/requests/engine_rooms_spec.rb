# frozen_string_literal: true

require "rails_helper"

RSpec.describe("EngineRooms", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /engine-room" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get engine_room_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get engine_room_path
        expect(response).to(have_http_status(:ok))
      end

      it "lists users" do
        other = create(:user, username: "leitor")

        get engine_room_path

        expect(response.body).to(include(admin.username))
        expect(response.body).to(include(other.username))
      end

      describe "statistics cards" do
        it "displays comics count" do
          create(:comic)

          get engine_room_path

          expect(response.body).to(include("Quadrinhos", 'data-counter-value-value="1"'))
        end

        it "displays collections count" do
          create(:collection)

          get engine_room_path

          expect(response.body).to(include("Coleções", 'data-counter-value-value="1"'))
        end

        it "displays authors count" do
          create(:author)

          get engine_room_path

          expect(response.body).to(include("Autores", 'data-counter-value-value="1"'))
        end

        it "displays characters count" do
          create(:character)

          get engine_room_path

          expect(response.body).to(include("Personagens", 'data-counter-value-value="1"'))
        end

        it "displays publishers count" do
          create(:publisher)

          get engine_room_path

          expect(response.body).to(include("Editoras", 'data-counter-value-value="1"'))
        end

        it "displays book bindings count" do
          create(:book_binding)

          get engine_room_path

          expect(response.body).to(include("Encadernações", 'data-counter-value-value="1"'))
        end

        it "displays paper types count" do
          create(:paper_type)

          get engine_room_path

          expect(response.body).to(include("Tipos de papel", 'data-counter-value-value="1"'))
        end

        it "displays publication types count" do
          create(:publication_type)

          get engine_room_path

          expect(response.body).to(include("Tipos de HQ", 'data-counter-value-value="1"'))
        end
      end
    end
  end
end
