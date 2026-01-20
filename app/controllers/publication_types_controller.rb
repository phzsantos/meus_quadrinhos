# frozen_string_literal: true

class PublicationTypesController < ApplicationController
  before_action :set_publication_type, only: [:show, :edit, :update, :destroy]

  # GET /publication_types or /publication_types.json
  def index
    @publication_types = PublicationType.all.order(:name)
  end

  # GET /publication_types/1 or /publication_types/1.json
  def show
  end

  # GET /publication_types/new
  def new
    @publication_type = PublicationType.new
  end

  # GET /publication_types/1/edit
  def edit
  end

  # POST /publication_types or /publication_types.json
  def create
    @publication_type = PublicationType.new(publication_type_params)

    respond_to do |format|
      if @publication_type.save
        format.html { redirect_to(@publication_type, notice: "Tipo de quadrinho criado com sucesso.") }
        format.json { render(:show, status: :created, location: @publication_type) }
      else
        format.html { render(:new, status: :unprocessable_content) }
        format.json { render(json: @publication_type.errors, status: :unprocessable_content) }
      end
    end
  end

  # PATCH/PUT /publication_types/1 or /publication_types/1.json
  def update
    respond_to do |format|
      if @publication_type.update(publication_type_params)
        format.html { redirect_to(@publication_type, notice: "Tipo de quadrinho atualizado com sucesso.", status: :see_other) }
        format.json { render(:show, status: :ok, location: @publication_type) }
      else
        format.html { render(:edit, status: :unprocessable_content) }
        format.json { render(json: @publication_type.errors, status: :unprocessable_content) }
      end
    end
  end

  # DELETE /publication_types/1 or /publication_types/1.json
  def destroy
    @publication_type.destroy!

    respond_to do |format|
      format.html { redirect_to(publication_types_path, notice: "Tipo de quadrinho foi deletado com sucesso.", status: :see_other) }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_publication_type
    @publication_type = PublicationType.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def publication_type_params
    params.require(:publication_type).permit(:name)
  end
end
