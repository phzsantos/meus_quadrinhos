# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, except: [:index, :show]
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  # GET /authors or /authors.json
  def index
    @authors = Author
      .includes(:comics)
      .order(:name)
      .page(params[:page])
      .per(20)
  end

  # GET /authors/1 or /authors/1.json
  def show
    @comics = @author.comics.order(:title, :issue_number).page(params[:page]).per(18)
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1/edit
  def edit
  end

  def export
    authors = Author.order(:created_at)

    render(json: authors.map { |author| export_author(author) })
  end

  # POST /authors or /authors.json
  def create
    @author = Author.new(author_params)

    respond_to do |format|
      if @author.save
        format.html { redirect_to(@author, notice: "Autor criado com sucesso.") }
        format.json { render(:show, status: :created, location: @author) }
      else
        format.html { render(:new, status: :unprocessable_content) }
        format.json { render(json: @author.errors, status: :unprocessable_content) }
      end
    end
  end

  # PATCH/PUT /authors/1 or /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to(@author, notice: "Autor atualizado com sucesso.", status: :see_other) }
        format.json { render(:show, status: :ok, location: @author) }
      else
        format.html { render(:edit, status: :unprocessable_content) }
        format.json { render(json: @author.errors, status: :unprocessable_content) }
      end
    end
  end

  # DELETE /authors/1 or /authors/1.json
  def destroy
    if @author.destroy
      redirect_to(
        authors_path,
        notice: "Autor foi deletado com sucesso.",
        status: :see_other,
      )
    else
      redirect_to(
        authors_path,
        alert: @author.errors.full_messages.to_sentence,
        status: :see_other,
      )
    end
  end

  private

  def export_author(author)
    author.name
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_author
    @author = Author.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def author_params
    params.require(:author).permit(:name)
  end
end
