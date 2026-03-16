# frozen_string_literal: true

class ComicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comic, only: [:show, :edit, :update, :destroy]

  # GET /comics or /comics.json
  def index
    @comics = Comic.includes(:readings)
      .order(created_at: :asc)
      .sort_by { |comic| comic.readings.maximum(:read_at) || Date.new(1970, 1, 1) }
  end

  # GET /comics/1 or /comics/1.json
  def show
  end

  # GET /comics/new
  def new
    @comic = Comic.new
  end

  # GET /comics/1/edit
  def edit
  end

  def export
    comics = Comic
      .includes(
        :publisher,
        :publication_type,
        :book_binding,
        :paper_type,
        :collection,
        :authors,
        :characters,
        :readings,
      )
      .order(:created_at)

    render(json: comics.map { |comic| export_comic(comic) })
  end

  # POST /comics or /comics.json
  def create
    @comic = Comic.new(comic_params)
    @comic.cover_image.attach(comic_params[:cover_image]) if comic_params[:cover_image].present?

    respond_to do |format|
      if @comic.save
        format.html { redirect_to(@comic, notice: "Quadrinho criado com sucesso.") }
        format.json { render(:show, status: :created, location: @comic) }
      else
        format.html { render(:new, status: :unprocessable_content) }
        format.json { render(json: @comic.errors, status: :unprocessable_content) }
      end
    end
  end

  # PATCH/PUT /comics/1 or /comics/1.json
  def update
    respond_to do |format|
      if @comic.update(comic_params)
        format.html { redirect_to(@comic, notice: "Quadrinho atualizado com sucesso.", status: :see_other) }
        format.json { render(:show, status: :ok, location: @comic) }
      else
        format.html { render(:edit, status: :unprocessable_content) }
        format.json { render(json: @comic.errors, status: :unprocessable_content) }
      end
    end
  end

  # DELETE /comics/1 or /comics/1.json
  def destroy
    @comic.destroy!

    respond_to do |format|
      format.html { redirect_to(comics_path, notice: "Quadrinho foi deletado com sucesso.", status: :see_other) }
      format.json { head(:no_content) }
    end
  end

  private

  def export_comic(comic)
    {
      title: comic.title,
      page_count: comic.page_count,
      collection_name: comic.collection&.name,
      published_year: comic.published_year,
      author_names: comic.authors.pluck(:name),
      character_names: comic.characters.pluck(:name),
      publisher_name: comic.publisher.name,
      publication_type_name: comic.publication_type.name,
      book_binding_name: comic.book_binding.name,
      paper_type_name: comic.paper_type.name,
      link_guia_dos_quadrinhos: comic.link_guia_dos_quadrinhos,
      story_count: comic.story_count,
      read_dates: comic.readings
        .where.not(read_at: nil)
        .order(:read_at)
        .pluck(:read_at)
        .map { |d| d.to_date.iso8601 },
    }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_comic
    @comic = Comic.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comic_params
    params.require(:comic).permit(
      :title,
      :page_count,
      :published_year,
      :publisher_id,
      :publication_type_id,
      :book_binding_id,
      :paper_type_id,
      :collection_id,
      :cover_image,
      :link_guia_dos_quadrinhos,
      :story_count,
      readings_attributes: [:id, :read_at, :_destroy],
      author_ids: [],
      character_ids: [],
    )
  end
end
