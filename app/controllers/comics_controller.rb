# frozen_string_literal: true

class ComicsController < ApplicationController
  before_action :set_comic, only: [:show, :edit, :update, :destroy]

  # GET /comics or /comics.json
  def index
    @comics = Comic.all.order(:read_date, :created_at)
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

  # POST /comics or /comics.json
  def create
    @comic = Comic.new(comic_params)
    @comic.cover_image.attach(comic_params[:cover_image]) if comic_params[:cover_image].present?

    respond_to do |format|
      if @comic.save
        format.html { redirect_to(@comic, notice: "Comic was successfully created.") }
        format.json { render(:show, status: :created, location: @comic) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @comic.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /comics/1 or /comics/1.json
  def update
    respond_to do |format|
      if @comic.update(comic_params)
        format.html { redirect_to(@comic, notice: "Comic was successfully updated.", status: :see_other) }
        format.json { render(:show, status: :ok, location: @comic) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @comic.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /comics/1 or /comics/1.json
  def destroy
    @comic.destroy!

    respond_to do |format|
      format.html { redirect_to(comics_path, notice: "Comic was successfully destroyed.", status: :see_other) }
      format.json { head(:no_content) }
    end
  end

  private

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
      :read_date,
      :cover_image,
      :link_guia_dos_quadrinhos,
      author_ids: [],
    )
  end
end
