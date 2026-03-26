# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Comics", type: :request) do
  let!(:publisher)        { create(:publisher) }
  let!(:publication_type) { create(:publication_type) }
  let!(:book_binding)     { create(:book_binding) }
  let!(:paper_type)       { create(:paper_type) }
  let!(:collection)       { create(:collection) }
  let!(:author)           { create(:author) }
  let!(:character)        { create(:character) }

  let(:valid_attributes) do
    {
      title: "Tex Willer #1",
      page_count: 100,
      published_year: 2020,
      publisher_id: publisher.id,
      publication_type_id: publication_type.id,
      book_binding_id: book_binding.id,
      paper_type_id: paper_type.id,
      collection_id: collection.id,
      story_count: 3,
      author_ids: [author.id],
      character_ids: [character.id],
      readings_attributes: [
        { read_at: Time.zone.today },
      ],
    }
  end

  let(:invalid_attributes) do
    {
      title: "",
      page_count: nil,
      published_year: nil,
    }
  end

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /comics" do
    it "retorna sucesso" do
      get comics_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /comics/:id" do
    it "retorna sucesso" do
      comic = create(:comic)

      get comic_path(comic)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /comics/new" do
    it "retorna sucesso" do
      get new_comic_path

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /comics/:id/edit" do
    it "retorna sucesso" do
      comic = create(:comic)

      get edit_comic_path(comic)

      expect(response).to(have_http_status(:ok))
    end
  end

  describe "POST /comics" do
    context "com parâmetros válidos" do
      it "cria um comic" do
        expect do
          post(comics_path, params: { comic: valid_attributes })
        end.to(change(Comic, :count).by(1))

        expect(response).to(redirect_to(comic_path(Comic.last)))
      end
    end

    context "com parâmetros inválidos" do
      it "não cria e renderiza new" do
        expect do
          post(comics_path, params: { comic: invalid_attributes })
        end.not_to(change(Comic, :count))

        expect(response).to(have_http_status(:unprocessable_content))
      end
    end
  end

  describe "PATCH /comics/:id" do
    let!(:comic) { create(:comic) }

    context "com parâmetros válidos" do
      it "atualiza o comic" do
        patch comic_path(comic), params: {
          comic: { title: "Novo título" },
        }

        expect(response).to(redirect_to(comic_path(comic.reload)))
        expect(comic.reload.title).to(eq("Novo título"))
      end
    end

    context "com parâmetros inválidos" do
      it "não atualiza e renderiza edit" do
        patch comic_path(comic), params: {
          comic: { title: "" },
        }

        expect(response).to(have_http_status(:unprocessable_content))
        expect(comic.reload.title).not_to(eq(""))
      end
    end
  end

  describe "DELETE /comics/:id" do
    it "remove o comic" do
      comic = create(:comic)

      expect do
        delete(comic_path(comic))
      end.to(change(Comic, :count).by(-1))

      expect(response).to(redirect_to(comics_path))
    end
  end
end
