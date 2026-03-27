# frozen_string_literal: true

class PaperTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, except: [:index, :show]
  before_action :set_paper_type, only: [:show, :edit, :update, :destroy]

  # GET /paper_types or /paper_types.json
  def index
    @paper_types = PaperType.all.order(:name)
  end

  # GET /paper_types/1 or /paper_types/1.json
  def show
  end

  # GET /paper_types/new
  def new
    @paper_type = PaperType.new
  end

  # GET /paper_types/1/edit
  def edit
  end

  # POST /paper_types or /paper_types.json
  def create
    @paper_type = PaperType.new(paper_type_params)

    respond_to do |format|
      if @paper_type.save
        format.html { redirect_to(@paper_type, notice: "Tipo de papel criado com sucesso.") }
        format.json { render(:show, status: :created, location: @paper_type) }
      else
        format.html { render(:new, status: :unprocessable_content) }
        format.json { render(json: @paper_type.errors, status: :unprocessable_content) }
      end
    end
  end

  # PATCH/PUT /paper_types/1 or /paper_types/1.json
  def update
    respond_to do |format|
      if @paper_type.update(paper_type_params)
        format.html { redirect_to(@paper_type, notice: "Tipo de papel atualizado com sucesso.", status: :see_other) }
        format.json { render(:show, status: :ok, location: @paper_type) }
      else
        format.html { render(:edit, status: :unprocessable_content) }
        format.json { render(json: @paper_type.errors, status: :unprocessable_content) }
      end
    end
  end

  # DELETE /paper_types/1 or /paper_types/1.json
  def destroy
    @paper_type.destroy!

    respond_to do |format|
      format.html { redirect_to(paper_types_path, notice: "Tipo de papel foi deletado com sucesso.", status: :see_other) }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_paper_type
    @paper_type = PaperType.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def paper_type_params
    params.require(:paper_type).permit(:name)
  end
end
