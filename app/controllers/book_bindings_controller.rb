# frozen_string_literal: true

class BookBindingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, except: [:index, :show]
  before_action :set_book_binding, only: [:show, :edit, :update, :destroy]

  # GET /book_bindings or /book_bindings.json
  def index
    @book_bindings = BookBinding.all.order(:name)
  end

  # GET /book_bindings/1 or /book_bindings/1.json
  def show
  end

  # GET /book_bindings/new
  def new
    @book_binding = BookBinding.new
  end

  # GET /book_bindings/1/edit
  def edit
  end

  # POST /book_bindings or /book_bindings.json
  def create
    @book_binding = BookBinding.new(book_binding_params)

    respond_to do |format|
      if @book_binding.save
        format.html { redirect_to(@book_binding, notice: "Encadernação criada com sucesso.") }
        format.json { render(:show, status: :created, location: @book_binding) }
      else
        format.html { render(:new, status: :unprocessable_content) }
        format.json { render(json: @book_binding.errors, status: :unprocessable_content) }
      end
    end
  end

  # PATCH/PUT /book_bindings/1 or /book_bindings/1.json
  def update
    respond_to do |format|
      if @book_binding.update(book_binding_params)
        format.html { redirect_to(@book_binding, notice: "Encadernação atualizada com sucesso.", status: :see_other) }
        format.json { render(:show, status: :ok, location: @book_binding) }
      else
        format.html { render(:edit, status: :unprocessable_content) }
        format.json { render(json: @book_binding.errors, status: :unprocessable_content) }
      end
    end
  end

  # DELETE /book_bindings/1 or /book_bindings/1.json
  def destroy
    @book_binding.destroy!

    respond_to do |format|
      format.html { redirect_to(book_bindings_path, notice: "Encadernação foi deletada com sucesso.", status: :see_other) }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book_binding
    @book_binding = BookBinding.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_binding_params
    params.require(:book_binding).permit(:name)
  end
end
