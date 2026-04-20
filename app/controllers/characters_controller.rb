# frozen_string_literal: true

class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, except: [:index, :show]
  before_action :set_character, only: [:show, :edit, :update, :destroy]

  # GET /characters or /characters.json
  def index
    @characters = Character
      .includes(:comics)
      .order(:name)
      .page(params[:page])
      .per(20)
  end

  # GET /characters/1 or /characters/1.json
  def show
    @comics = @character.comics.order(:title).page(params[:page]).per(18)
  end

  # GET /characters/new
  def new
    @character = Character.new
  end

  # GET /characters/1/edit
  def edit
  end

  # POST /characters or /characters.json
  def create
    @character = Character.new(character_params)

    respond_to do |format|
      if @character.save
        format.html { redirect_to(@character, notice: "Personagem criado com sucesso.") }
        format.json { render(:show, status: :created, location: @character) }
      else
        format.html { render(:new, status: :unprocessable_content) }
        format.json { render(json: @character.errors, status: :unprocessable_content) }
      end
    end
  end

  # PATCH/PUT /characters/1 or /characters/1.json
  def update
    respond_to do |format|
      if @character.update(character_params)
        format.html { redirect_to(@character, notice: "Personagem atualizado com sucesso.", status: :see_other) }
        format.json { render(:show, status: :ok, location: @character) }
      else
        format.html { render(:edit, status: :unprocessable_content) }
        format.json { render(json: @character.errors, status: :unprocessable_content) }
      end
    end
  end

  # DELETE /characters/1 or /characters/1.json
  def destroy
    @character.destroy!

    respond_to do |format|
      format.html { redirect_to(characters_path, notice: "Personagem foi deletado com sucesso.", status: :see_other) }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_character
    @character = Character.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def character_params
    params.require(:character).permit(:name)
  end
end
