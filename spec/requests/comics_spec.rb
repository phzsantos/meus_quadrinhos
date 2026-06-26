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

    it "returns success" do
      get comics_path
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /comics/:id" do
    before { sign_in user }

    it "returns success" do
      comic = create(:comic)

      get comic_path(comic)
      expect(response).to(have_http_status(:ok))
    end
  end

  describe "GET /comics/new" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get new_comic_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get new_comic_path
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "GET /comics/:id/edit" do
    let(:comic) { create(:comic) }

    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get edit_comic_path(comic)
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "allows access" do
        get edit_comic_path(comic)
        expect(response).to(have_http_status(:ok))
      end
    end
  end

  describe "POST /comics" do
    context "as regular user" do
      before { sign_in user }

      it "does not create comic" do
        expect do
          post(comics_path, params: { comic: valid_attributes })
        end.not_to(change(Comic, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "creates a comic" do
          expect do
            post(comics_path, params: { comic: valid_attributes })
          end.to(change(Comic, :count).by(1))

          expect(response).to(redirect_to(comic_path(Comic.last)))
        end
      end

      context "with invalid parameters" do
        it "does not create and renders new" do
          expect do
            post(comics_path, params: { comic: invalid_attributes })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without title" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(title: "") })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without page_count" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(page_count: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without story_count" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(story_count: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without published_year" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(published_year: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without authors" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(author_ids: []) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without characters" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(character_ids: []) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without publisher_id" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(publisher_id: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without publication_type_id" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(publication_type_id: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without book_binding_id" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(book_binding_id: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without paper_type_id" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(paper_type_id: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without issue_number" do
          expect do
            post(comics_path, params: { comic: valid_attributes.merge(issue_number: nil) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create without cover_image" do
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

    context "as regular user" do
      before { sign_in user }

      it "does not update" do
        patch comic_path(comic), params: {
          comic: { title: "New Title" },
        }

        expect(response).to(redirect_to(root_path))
        expect(comic.reload.title).not_to(eq("New Title"))
      end
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid parameters" do
        it "updates the comic" do
          patch comic_path(comic), params: {
            comic: {
              title: "New Title",
              cover_image: fixture_file_upload(Rails.root.join("spec/fixtures/files/test-cover.jpg"), "image/jpeg"),
            },
          }

          expect(response).to(redirect_to(comic_path(comic.reload)))
          expect(comic.reload.title).to(eq("New Title"))
        end
      end

      context "with invalid parameters" do
        it "does not update and renders edit" do
          patch comic_path(comic), params: {
            comic: { title: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.title).not_to(eq(""))
        end

        it "does not update without title" do
          patch comic_path(comic), params: {
            comic: { title: "" },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.title).not_to(eq(""))
        end

        it "does not update without issue_number" do
          patch comic_path(comic), params: {
            comic: { issue_number: nil },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.issue_number).not_to(be_nil)
        end

        it "does not update without page_count" do
          patch comic_path(comic), params: {
            comic: { page_count: nil },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.page_count).not_to(be_nil)
        end

        it "does not update without story_count" do
          patch comic_path(comic), params: {
            comic: { story_count: nil },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.story_count).not_to(be_nil)
        end

        it "does not update without published_year" do
          patch comic_path(comic), params: {
            comic: { published_year: nil },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.published_year).not_to(be_nil)
        end

        it "does not update without authors" do
          patch comic_path(comic), params: {
            comic: { author_ids: [] },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.authors).not_to(be_empty)
        end

        it "does not update without characters" do
          patch comic_path(comic), params: {
            comic: { character_ids: [] },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.characters).not_to(be_empty)
        end

        it "does not update without publisher_id" do
          patch comic_path(comic), params: {
            comic: { publisher_id: nil },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.publisher_id).not_to(be_nil)
        end

        it "does not update without publication_type_id" do
          patch comic_path(comic), params: {
            comic: { publication_type_id: nil },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.publication_type_id).not_to(be_nil)
        end

        it "does not update without book_binding_id" do
          patch comic_path(comic), params: {
            comic: { book_binding_id: nil },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.book_binding_id).not_to(be_nil)
        end

        it "does not update without paper_type_id" do
          patch comic_path(comic), params: {
            comic: { paper_type_id: nil },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.paper_type_id).not_to(be_nil)
        end

        it "does not update without cover_image" do
          patch comic_path(comic), params: {
            comic: { cover_image: nil },
          }

          expect(response).to(have_http_status(:unprocessable_content))
        end
      end
    end
  end

  describe "DELETE /comics/:id" do
    let!(:comic) { create(:comic) }

    context "as regular user" do
      before { sign_in user }

      it "does not remove" do
        expect do
          delete(comic_path(comic))
        end.not_to(change(Comic, :count))

        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "removes the comic" do
        expect do
          delete(comic_path(comic))
        end.to(change(Comic, :count).by(-1))

        expect(response).to(redirect_to(comics_path))
      end
    end
  end
end
