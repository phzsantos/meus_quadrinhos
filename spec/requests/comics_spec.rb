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

    it "shows an empty list when the user has no owned or read comics" do
      create(:comic)

      get comics_path

      expect(response).to(have_http_status(:ok))
      expect(response.body).to(include("Quadrinho (0)"))
    end

    it "shows Lido and Tenho columns for owned comics" do
      comic = create(:comic, title: "Batman Owned")
      create(:reading, user: user, comic: comic, read_at: Date.new(2025, 1, 10))
      create(:user_comic, user: user, comic: comic)

      get comics_path

      expect(response.body).to(include("Lido"))
      expect(response.body).to(include("Tenho"))
      expect(response.body).to(include("Batman Owned"))
      expect(response.body).to(include("10/01/2025"))
    end

    it "includes comics the user only read" do
      comic = create(:comic, title: "Only Read Comic")
      create(:reading, user: user, comic: comic, read_at: Date.new(2026, 2, 1))

      get comics_path

      expect(response.body).to(include("Only Read Comic"))
      expect(response.body).to(include("01/02/2026"))
    end
  end

  describe "GET /comics/:id" do
    before { sign_in user }

    it "returns success" do
      comic = create(:comic)

      get comic_path(comic)
      expect(response).to(have_http_status(:ok))
    end

    it "shows membership actions for the user" do
      comic = create(:comic)
      create(:user_comic, user: user, comic: comic)

      get comic_path(comic)

      expect(response.body).to(include("Adicionar leitura"))
      expect(response.body).to(include(edit_comic_membership_path(comic)))
      expect(response.body).to(include("Remover quadrinho da coleção"))
      expect(response.body).not_to(include(">Editar<"))
    end

    it "shows add to collection when the user does not own the comic" do
      comic = create(:comic)

      get comic_path(comic)

      expect(response.body).to(include("Adicionar quadrinho à coleção"))
    end
  end

  describe "GET /comics/browse" do
    before { sign_in user }

    it "returns success" do
      get browse_comics_path
      expect(response).to(have_http_status(:ok))
    end

    it "lists comics the user does not own" do
      create(:comic, title: "Available Comic")
      owned = create(:comic, title: "Already Owned")
      create(:user_comic, user: user, comic: owned)

      get browse_comics_path

      expect(response.body).to(include("Available Comic"))
      expect(response.body).not_to(include("Already Owned"))
    end

    it "includes the stimulus filter markup" do
      comic = create(:comic, title: "Batman Year One")

      get browse_comics_path

      expect(response.body).to(include('data-controller="comic-filter"'))
      expect(response.body).to(include("data-comic-filter-title=\"#{comic.display_title}\""))
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
        expect(response.body).to(include("Editar Quadrinho"))
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

        it "adds the comic to the admin's collection" do
          expect do
            post(comics_path, params: { comic: valid_attributes })
          end.to(change { admin.owned_comics.count }.by(1))

          expect(admin.owned_comics).to(include(Comic.last))
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

        it "does not create with duplicated title, issue_number and published_year" do
          post(comics_path, params: { comic: valid_attributes })

          expect do
            post(comics_path, params: { comic: valid_attributes })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "does not create with duplicated title, issue_number and published_year case insensitive" do
          post(comics_path, params: { comic: valid_attributes })

          expect do
            post(comics_path, params: { comic: valid_attributes.merge(title: "tex willer #1", issue_number: 1) })
          end.not_to(change(Comic, :count))

          expect(response).to(have_http_status(:unprocessable_content))
        end

        it "creates comic with same title and issue_number but different published_year" do
          post(comics_path, params: { comic: valid_attributes })

          expect do
            post(comics_path, params: { comic: valid_attributes.merge(published_year: 2021) })
          end.to(change(Comic, :count).by(1))

          expect(response).to(redirect_to(comic_path(Comic.find_by!(published_year: 2021))))
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

        it "does not update with duplicated title, issue_number and published_year" do
          create(:comic, title: "Tex Willer #1", issue_number: 1, published_year: 2020)

          patch comic_path(comic), params: {
            comic: { title: "Tex Willer #1", issue_number: 1, published_year: 2020 },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.title).not_to(eq("Tex Willer #1"))
        end

        it "does not update with duplicated title, issue_number and published_year case insensitive" do
          create(:comic, title: "Tex Willer #1", issue_number: 1, published_year: 2020)

          patch comic_path(comic), params: {
            comic: { title: "tex willer #1", issue_number: 1, published_year: 2020 },
          }

          expect(response).to(have_http_status(:unprocessable_content))
          expect(comic.reload.title).not_to(eq("tex willer #1"))
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

  describe "GET /comics/export" do
    context "as regular user" do
      before { sign_in user }

      it "blocks access" do
        get export_comics_path
        expect(response).to(redirect_to(root_path))
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "exports comics as JSON in seed format" do
        comic = create(
          :comic,
          title: "Tex Willer Export",
          page_count: 124,
          published_year: 2019,
          issue_number: 99,
          issue_title: "Tex contra o mundo",
          story_count: 5,
          link_guia_dos_quadrinhos: "http://example.com/edicao",
          authors: [author],
          characters: [character],
          publisher: publisher,
          publication_type: publication_type,
          book_binding: book_binding,
          paper_type: paper_type,
          collection: collection,
        )
        create(:reading, comic: comic, read_at: Date.new(2025, 10, 8))

        get export_comics_path

        expect(response).to(have_http_status(:ok))
        expect(response.parsed_body).to(eq([
          {
            "title" => "Tex Willer Export",
            "page_count" => 124,
            "collection_name" => collection.name,
            "published_year" => 2019,
            "author_names" => [author.name],
            "character_names" => [character.name],
            "publisher_name" => publisher.name,
            "publication_type_name" => publication_type.name,
            "book_binding_name" => book_binding.name,
            "paper_type_name" => paper_type.name,
            "link_guia_dos_quadrinhos" => "http://example.com/edicao",
            "story_count" => 5,
            "read_dates" => ["2025-10-08"],
            "issue_number" => 99,
            "issue_title" => "Tex contra o mundo",
          },
        ]))
      end
    end
  end
end
