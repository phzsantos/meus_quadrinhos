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
      issue_number: 1,
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
      cover_image: fixture_file_upload(Rails.root.join("spec/fixtures/files/test-cover.jpg"), "image/jpeg"),
    }
  end

  let(:invalid_attributes) do
    {
      title: "",
      page_count: nil,
      story_count: nil,
      published_year: nil,
      issue_number: nil,
      author_ids: [],
      publisher_id: nil,
      publication_type_id: nil,
      book_binding_id: nil,
      paper_type_id: nil,
      character_ids: [],
      cover_image: nil,
    }
  end

  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET /comics" do
    before { sign_in user }

    it "retorna sucesso" do
      get comics_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /comics/:id" do
    before { sign_in user }

    it "retorna sucesso" do
      comic = create(:comic)

      get comic_path(comic)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /comics/new" do
    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get new_comic_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get new_comic_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /comics/:id/edit" do
    let(:comic) { create(:comic) }

    context "como usuário comum" do
      before { sign_in user }

      it "bloqueia acesso" do
        get edit_comic_path(comic)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "permite acesso" do
        get edit_comic_path(comic)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /comics" do
    context "como usuário comum" do
      before { sign_in user }

      it "não cria comic" do
        expect do
          post(comics_path, params: { comic: valid_attributes })
        end.not_to(change(Comic, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

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

        it "tenta criar sem title" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(title: "") })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem page_count" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(page_count: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem story_count" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(story_count: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem published_year" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(published_year: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem authors" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(author_ids: []) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem characters" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(character_ids: []) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem publisher_id" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(publisher_id: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem publication_type_id" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(publication_type_id: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem book_binding_id" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(book_binding_id: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem paper_type_id" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(paper_type_id: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem issue_number" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(issue_number: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "tenta criar sem cover_image" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(cover_image: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "PATCH /comics/:id" do
    let!(:comic) { create(:comic) }

    context "como usuário comum" do
      before { sign_in user }

      it "não atualiza" do
        patch comic_path(comic), params: {
          comic: { title: "Novo título" },
        }

        expect(response).to(redirect_to(root_path))
        expect(comic.reload.title).not_to(eq("Novo título"))
      end
    end

    context "como admin" do
      before { sign_in admin }

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
  end

  describe "DELETE /comics/:id" do
    let!(:comic) { create(:comic) }

    context "como usuário comum" do
      before { sign_in user }

      it "não remove" do
        expect do
          delete(comic_path(comic))
        end.not_to(change(Comic, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "como admin" do
      before { sign_in admin }

      it "remove o comic" do
        expect do
          delete(comic_path(comic))
        end.to(change(Comic, :count).by(-1))

        expect(response).to(redirect_to(comics_path))
      end
    end
  end
end
